#
# Managed Environments
#

resource "cycloid_cloud_account" "aws" {
  count = var.aws_cred_infra != "" ? 1 : 0

  organization         = var.cy_child_org_canonical
  name                 = "AWS"
  cloud_provider       = "aws"
  credential_canonical = cycloid_credential.aws[0].canonical
  description          = "AWS account for managed environments"
}

resource "cycloid_cloud_account" "azure" {
  count = var.azure_cred_infra != "" ? 1 : 0

  organization         = var.cy_child_org_canonical
  name                 = "Azure"
  cloud_provider       = "azurerm"
  credential_canonical = cycloid_credential.azure[0].canonical
  description          = "Azure subscription for managed environments"
}

locals {
  managed_environments = toset(var.managed_environments)

  managed_environment_types = {
    DEV        = "development"
    STAGING    = "staging"
    PREPROD    = "staging"
    PRODUCTION = "production"
    OTH-DEV    = "development"
    PPE        = "staging"
    PRD        = "production"
  }

  managed_environment_variables_string = trim(try(
    jsondecode(var.managed_environment_variables),
    var.managed_environment_variables,
  ))

  managed_environment_variables_normalized = replace(
    replace(
      replace(
        replace(local.managed_environment_variables_string, "\\n", "\n"),
        "\\\"", "\""
      ),
      "\\t", "\t"
    ),
    "\\r", ""
  )

  managed_environment_variables_parsed = (
    can(tolist(var.managed_environment_variables))
    ? var.managed_environment_variables
    : yamldecode(local.managed_environment_variables_normalized)
  )

  managed_environment_variables = [
    for v in local.managed_environment_variables_parsed : {
      key         = v.key
      type        = try(v.type, "string")
      value       = tostring(v.value)
      description = try(v.description, "")
      sensitive   = try(v.sensitive, false)
    }
  ]

  managed_environment_cloud_accounts = compact([
    length(cycloid_cloud_account.aws) > 0 ? cycloid_cloud_account.aws[0].canonical : null,
    length(cycloid_cloud_account.azure) > 0 ? cycloid_cloud_account.azure[0].canonical : null,
  ])
}

resource "cycloid_environment" "managed" {
  for_each = local.managed_environments

  organization = var.cy_child_org_canonical
  project      = cycloid_project.infrastructure.canonical
  canonical    = each.key
  name         = each.key
  type         = lookup(local.managed_environment_types, each.key, "development")
  owner        = var.project_owner

  cloud_account_canonicals = local.managed_environment_cloud_accounts
  variables                = local.managed_environment_variables

  depends_on = [
    cycloid_cloud_account.aws,
    cycloid_cloud_account.azure,
  ]
}

resource "cycloid_environment_link" "application" {
  for_each = cycloid_environment.managed

  organization = var.cy_child_org_canonical
  project      = cycloid_project.application.canonical
  environment  = each.value.canonical
}
