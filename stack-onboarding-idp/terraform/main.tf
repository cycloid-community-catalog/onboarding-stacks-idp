#
# Cycloid Organization
#
resource "cycloid_organization" "org" {
  name                   = var.cy_child_org
  organization_canonical = var.cy_org

  lifecycle {
    ignore_changes = [organization_canonical]
  }
}

#
# Terraform backend
#
resource "cycloid_credential" "s3-cycloid" {
  name                   = "s3-cycloid"
  description            = "AWS IAM user credential allowing access to an S3 bucket used as Terraform backend for your Cycloid organization."
  organization_canonical = var.cy_child_org
  path                   = "s3-cycloid"
  canonical              = "s3-cycloid"

  type = "aws"
  body = {
    access_key = var.cycloid_s3_access_key
    secret_key = var.cycloid_s3_secret_key
  }
}

resource "cycloid_external_backend" "tf_external_backend" {
  organization_canonical = var.cy_child_org
  credential_canonical = cycloid_credential.s3-cycloid.canonical
  default = true
  purpose = "remote_tfstate"
  engine = "aws_storage"
  aws_storage = {
    bucket = "${var.cy_child_org}-terraform-remote-state"
    region = var.cycloid_s3_region
    endpoint = "https://s3.${var.cycloid_s3_region}.amazonaws.com"
    s3_force_path_style = false
    skip_verify_ssl = true
  }
}

#
# Stacks and Config
#
resource "cycloid_catalog_repository" "idp_repo" {
  name                   = "Internal Developer Portal Catalog Repository"
  url                    = "https://github.com/cycloid-community-catalog/onboarding-stacks-idp.git"
  branch                 = "master"
  organization_canonical = var.cy_child_org
}

resource "cycloid_catalog_repository" "catalog_repo" {
  name                   = "Your Catalog Repository"
  url                    = var.cycloid_git_url
  branch                 = "stacks"
  credential_canonical   = cycloid_credential.git-ssh.canonical
  organization_canonical = var.cy_child_org
}

resource "cycloid_config_repository" "config_repo" {
  name                   = "Your Config Repository"
  url                    = var.cycloid_git_url
  branch                 = "config"
  credential_canonical   = cycloid_credential.git-ssh.canonical
  default                = true
  organization_canonical = var.cy_child_org
}
