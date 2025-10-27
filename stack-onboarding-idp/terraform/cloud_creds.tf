resource "cycloid_credential" "aws" {
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