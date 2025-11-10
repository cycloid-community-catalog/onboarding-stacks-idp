resource "cycloid_credential" "aws" {
  count = var.aws_cred_infra != "" ? 1 : 0

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
  count = var.azure_cred_infra != "" ? 1 : 0
  
  name                   = "Azure"
  description            = "Azure subscription to use for the software project."
  path                   = "azure"
  canonical              = "azure"
  organization_canonical = var.cy_child_org_canonical

  type = "azure"
  body = {
    subscription_id = var.azure_cred_infra.subscription_id
    tenant_id = var.azure_cred_infra.tenant_id
    client_id = var.azure_cred_infra.client_id
    client_secret = var.azure_cred_infra.client_secret
  }
}

resource "cycloid_credential" "dockerhub" {
  name                   = "DockerHub"
  description            = "DockerHub credentials to access the application image registry."
  path                   = "dockerhub"
  canonical              = "dockerhub"
  organization_canonical = var.cy_child_org_canonical

  type = "basic_auth"
  body = {
    username = var.dockerhub_cred.username
    password = var.dockerhub_cred.password
  }
}

resource "cycloid_credential" "github-pat" {
  name                   = "GitHub PAT"
  description            = "GitHub Personal Access Token allowing to scaffold the application git repository. The token must be in the format of 'ghp_<token>', stored in the password field and be created with the 'repo' scope."
  path                   = "github-pat"
  canonical              = "github-pat"
  organization_canonical = var.cy_child_org_canonical

  type = "custom"
  body = {
    raw = {
      password = var.github_pat
      token = var.github_pat
    }
  }
}