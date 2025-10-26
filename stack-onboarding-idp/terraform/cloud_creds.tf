resource "cycloid_credential" "aws" {
  count = var.cloud_provider == "aws" ? 1 : 0

  name                   = "AWS"
  description            = "AWS account to use for the software project."
  path                   = "aws"
  canonical              = "aws"
  organization_canonical = var.cy_child_org_canonical

  type = "aws"
  body = {
    access_key = var.aws_cred_infra.access_key
    secret_key = var.aws_cred_infra.secret_key
  }
}

resource "cycloid_credential" "azure" {
  count = var.cloud_provider == "azure" ? 1 : 0

  name                   = "Azure"
  description            = "Azure account to use for the software project."
  path                   = "azure"
  canonical              = "azure"
  organization_canonical = var.cy_child_org_canonical

  type = "azure"
  body = {
    subscription_id = var.azure_cred_infra.subscription_id
    client_id       = var.azure_cred_infra.client_id
    client_secret   = var.azure_cred_infra.client_secret
    tenant_id       = var.azure_cred_infra.tenant_id
  }
}

resource "cycloid_credential" "gcp" {
  count = var.cloud_provider == "gcp" ? 1 : 0

  name                   = "GCP"
  description            = "GCP account to use for the software project."
  path                   = "gcp"
  canonical              = "gcp"
  organization_canonical = var.cy_child_org_canonical

  type = "gcp"
  body = {
    json_key = var.gcp_cred_infra.json_key
  }
}