#! /usr/bin/env bash

set -eu

export CY_API_KEY=${CY_API_KEY:?You need a cycloid API key}
export CY_API_URL=${CY_API_URL:?You need a cycloid API url}
export CY_ORG=${CY_ORG:?Fill your current org}

# To test your stack easily, use the CLI
#
# First, refresh the catalog
#
CATALOG_CANONICAL=terraform-cc-three-tiers

cy catalog-repository refresh --canonical "$CATALOG_CANONICAL"

# Then create/update the component
# Fill here the variables as JSON following your stackforms spec
# export CY_STACKFORMS_VARS="$(var <<EOF
# EOF
# )
# "

# Export the current cy context as env var
export CY_PROJECT=${CY_PROJECT:?Fill you current project}
export CY_ENV="${CY_ENV:?Fill your current env}"
export CY_COMPONENT="${CY_COMPONENT:?Fill your current component}"

# We need the name of the current branch for the stack
stack_branch="$(git branch --show-current)"
stack_canonical="$(cat .cycloid.yml | grep -i canonical | cut -d':' -f2)"
# change use case if needed
stack_use_case="deploy"

cy component create --update \
  --stack-branch "$stack_branch" \
  --stack-ref "${CY_ORG}:${stack_canonical}" \
  --use-case "$stack_use_case"
