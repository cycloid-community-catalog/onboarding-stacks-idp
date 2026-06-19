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
  managed_environments = toset(["DEV", "STAGING", "PREPROD", "PRODUCTION"])

  managed_environment_types = {
    DEV        = "development"
    STAGING    = "staging"
    PREPROD    = "staging"
    PRODUCTION = "production"
  }

  managed_environment_variables = [
    { key = "aws_region", type = "string", value = "eu-west-1", description = "", sensitive = false },
    { key = "cost_center", type = "string", value = "PRJ-2026-INFRA", description = "", sensitive = false },
    { key = "data_classification", type = "string", value = "internal", description = "", sensitive = false },
    { key = "dns_zone", type = "string", value = "demo.cycloid.io", description = "", sensitive = false },
    { key = "gcp_project", type = "string", value = "cycloid-demo", description = "", sensitive = false },
    { key = "gcp_region", type = "string", value = "europe-west1", description = "", sensitive = false },
    { key = "gcp_zone", type = "string", value = "europe-west1-b", description = "", sensitive = false },
    { key = "landing_zone_id", type = "string", value = "lz-dev-eu-001", description = "", sensitive = false },
    { key = "replicas", type = "string", value = "2", description = "", sensitive = false },
    { key = "vpc_id", type = "string", value = "vpc-020d5f766346ac179", description = "", sensitive = false },
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
  type         = local.managed_environment_types[each.key]
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
