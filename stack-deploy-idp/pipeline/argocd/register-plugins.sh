#!/usr/bin/env bash
set -euo pipefail

if [[ "${REGISTER_PLUGINS:-}" != "true" ]]; then
  echo "register_plugins is disabled — skipping plugin registration"
  exit 0
fi

resolve_plugin_registry() {
  if [[ -n "${PLUGIN_REGISTRY:-}" ]]; then
    if cy plugin registry get "${PLUGIN_REGISTRY}" >/dev/null 2>&1; then
      echo "${PLUGIN_REGISTRY}"
      return 0
    fi
    echo "error: plugin registry '${PLUGIN_REGISTRY}' not found in org ${CY_ORG}" >&2
    echo "Available registries:" >&2
    cy plugin registry list >&2 || true
    exit 1
  fi

  local registries count
  registries="$(cy plugin registry list -o json | jq -r '
    if type == "array" then .
    elif (.data | type) == "array" then .data
    else []
    end
    | .[]
    | (.canonical // .name // (.id | tostring))
  ')"
  count="$(printf '%s\n' "${registries}" | sed '/^$/d' | wc -l | tr -d ' ')"

  if [[ "${count}" == "1" ]]; then
    printf '%s\n' "${registries}" | head -1
    return 0
  fi

  echo "error: plugin_registry is not set and org ${CY_ORG} has ${count} registries" >&2
  echo "Set plugin_registry in pipeline/argocd/variables.yml to a registry name or numeric ID from:" >&2
  cy plugin registry list >&2 || true
  exit 1
}

resolve_registry_plugin() {
  local configured="${1}"
  shift
  local candidate

  for candidate in "${configured}" "$@"; do
    if [[ -n "${candidate}" ]] && cy plugin registry plugin get "${candidate}" --registry "${PLUGIN_REGISTRY}" >/dev/null 2>&1; then
      echo "${candidate}"
      return 0
    fi
  done

  echo "error: registry plugin '${configured}' not found in registry ${PLUGIN_REGISTRY}" >&2
  echo "Tried: ${configured} $*" >&2
  echo "Available plugins:" >&2
  cy plugin registry plugin list "${PLUGIN_REGISTRY}" >&2 || true
  echo "Set plugin_argocd_name in pipeline/argocd/variables.yml" >&2
  exit 1
}

resolve_plugin_version_id() {
  local registry_plugin="${1}"
  local configured="${2}"

  if [[ -n "${configured}" && "${configured}" != "latest" ]]; then
    if cy plugin registry plugin version get "${configured}" \
      --registry "${PLUGIN_REGISTRY}" \
      --plugin "${registry_plugin}" >/dev/null 2>&1; then
      echo "${configured}"
      return 0
    fi
    echo "warning: plugin version ${configured} not found for ${registry_plugin}, using latest" >&2
  fi

  local version_id
  version_id="$(cy plugin registry plugin version list \
    --registry "${PLUGIN_REGISTRY}" \
    --plugin "${registry_plugin}" \
    -o json | jq -r '
      if type == "array" then .
      elif (.data | type) == "array" then .data
      else []
      end
      | if length == 0 then empty else . end
      | max_by(.id // 0)
      | (.id | tostring)
    ')"

  if [[ -z "${version_id}" ]]; then
    echo "error: no versions published for plugin ${registry_plugin} in registry ${PLUGIN_REGISTRY}" >&2
    exit 1
  fi

  echo "${version_id}"
}

plugin_install_id_from_get() {
  local candidate="${1}"
  local install_id
  install_id="$(cy plugin get "${candidate}" -o json 2>/dev/null | jq -er '
    if type == "array" then .[0] else . end
    | .id // .install_id // empty
    | tostring
  ' 2>/dev/null || true)"
  if [[ "${install_id}" =~ ^[0-9]+$ ]]; then
    echo "${install_id}"
  fi
}

plugin_install_id_from_list() {
  local preferred="${1}"
  local registry_plugin="${2}"
  local install_id
  install_id="$(PREF="${preferred}" REG="${registry_plugin}" cy plugin list -o json | jq -er '
    def plugins:
      if type == "array" then .
      elif (.data | type) == "array" then .data
      else []
      end;
    def norm: ascii_downcase | gsub("[^a-z0-9]"; "");
    plugins[]
    | select(
        ((.name // "" | norm) == (env.PREF | norm))
        or ((.canonical // "" | norm) == (env.PREF | norm))
        or ((.install // "" | norm) == (env.PREF | norm))
        or ((.name // "" | norm) == (env.REG | norm))
        or ((.canonical // "" | norm) == (env.REG | norm))
        or ((.install // "" | norm) == (env.REG | norm))
      )
    | (.id // .install_id)
    | tostring
  ' 2>/dev/null | head -1 || true)"
  if [[ "${install_id}" =~ ^[0-9]+$ ]]; then
    echo "${install_id}"
  fi
}

plugin_install_is_ready() {
  local install_id="${1}"
  local status
  status="$(cy plugin get "${install_id}" -o json 2>/dev/null | jq -r '
    if type == "array" then .[0] else . end
    | (.status // "") | ascii_downcase
  ' 2>/dev/null || true)"
  case "${status}" in
    pending|starting|installing)
      return 1
      ;;
    failed|error|stopped)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

resolve_installed_plugin_ref() {
  local preferred="${1}"
  local registry_plugin="${2}"
  shift 2
  local candidate install_id attempt

  for attempt in $(seq 1 10); do
    for candidate in "${preferred}" "${registry_plugin}" "$@"; do
      if [[ -z "${candidate}" ]]; then
        continue
      fi
      install_id="$(plugin_install_id_from_get "${candidate}")"
      if [[ -n "${install_id}" ]] && plugin_install_is_ready "${install_id}"; then
        echo "${install_id}"
        return 0
      fi
    done

    install_id="$(plugin_install_id_from_list "${preferred}" "${registry_plugin}")"
    if [[ -n "${install_id}" ]] && plugin_install_is_ready "${install_id}"; then
      echo "${install_id}"
      return 0
    fi

    if [[ -n "${install_id}" ]]; then
      echo "waiting for plugin install ${install_id} to become ready (${attempt}/10)..." >&2
    else
      echo "waiting for plugin install to register (${attempt}/10)..." >&2
    fi
    sleep 3
  done

  echo "error: org plugin install not ready after install (tried: ${preferred}, ${registry_plugin})" >&2
  echo "Installed plugins:" >&2
  cy plugin list >&2 || true
  exit 1
}

install_or_upgrade_plugin() {
  local install_name="${1}"
  local registry_plugin="${2}"
  local version_id="${3}"
  shift 3
  local extra_args=( "$@" )

  local resolved_install_name="${install_name}"
  if ! cy plugin get "${resolved_install_name}" >/dev/null 2>&1 \
    && [[ "${registry_plugin}" != "${install_name}" ]] \
    && cy plugin get "${registry_plugin}" >/dev/null 2>&1; then
    resolved_install_name="${registry_plugin}"
  fi

  if cy plugin get "${resolved_install_name}" >/dev/null 2>&1; then
    echo "Upgrading plugin ${resolved_install_name}..." >&2
    cy plugin upgrade "${resolved_install_name}" --version-id "${version_id}" "${extra_args[@]}" >&2 || return 1
  else
    echo "Installing plugin ${registry_plugin} (version ${version_id})..." >&2
    cy plugin registry plugin version install "${version_id}" \
      --registry "${PLUGIN_REGISTRY}" \
      --plugin "${registry_plugin}" \
      --retry \
      "${extra_args[@]}" >&2 || return 1
  fi

  resolve_installed_plugin_ref \
    "${install_name}" \
    "${registry_plugin}" \
    "${resolved_install_name}"
}

enable_on_component() {
  local install_ref="${1}"
  echo "Enabling plugin install ${install_ref} on ${CY_PROJECT}/${CY_ENV}/${CY_COMPONENT}..."
  cy plugin component relation-set "${install_ref}" \
    --project "${CY_PROJECT}" \
    --env "${CY_ENV}" \
    --component "${CY_COMPONENT}" \
    --enabled || return 1
}

PLUGIN_REGISTRY="$(resolve_plugin_registry)"
echo "Using plugin registry: ${PLUGIN_REGISTRY}"

ARGOCD_REGISTRY_PLUGIN="$(resolve_registry_plugin \
  "${PLUGIN_ARGOCD_NAME}" \
  ArgoCD cycloid-plugin-argocd argocd plugin-argocd)"
echo "Using ArgoCD registry plugin: ${ARGOCD_REGISTRY_PLUGIN}"

ARGOCD_VERSION_ID="$(resolve_plugin_version_id \
  "${ARGOCD_REGISTRY_PLUGIN}" \
  "${PLUGIN_ARGOCD_VERSION_ID:-}")"
echo "Using ArgoCD version: ${ARGOCD_VERSION_ID}"

ARGOCD_CONFIG=(
  --config "argocd_username=${ARGOCD_USERNAME}"
  --config "argocd_password=${ARGOCD_PASSWORD}"
)

ARGOCD_INSTALL_REF="$(install_or_upgrade_plugin \
  "${PLUGIN_ARGOCD_INSTALL_NAME}" \
  "${ARGOCD_REGISTRY_PLUGIN}" \
  "${ARGOCD_VERSION_ID}" \
  "${ARGOCD_CONFIG[@]}")" || exit 1
enable_on_component "${ARGOCD_INSTALL_REF}" || exit 1

echo "ArgoCD plugin registered and enabled on component ${CY_COMPONENT}"
