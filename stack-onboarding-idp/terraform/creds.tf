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

resource "cycloid_credential" "github-pat" {
  name                   = "GitHub PAT"
  description            = "GitHub Personal Access Token allowing to scaffold the application git repository. The token must be in the format of 'ghp_<token>', stored in the password field and be created with the 'repo' scope."
  path                   = "github-pat"
  canonical              = "github-pat"
  organization_canonical = var.cy_child_org_canonical

  type = "custom"
  body = {
    raw = {
      token = var.github_pat
    }
  }
}