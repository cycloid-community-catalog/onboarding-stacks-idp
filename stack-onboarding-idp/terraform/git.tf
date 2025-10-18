#
# Cycloid GitHub repository
#
resource "github_repository" "idp-git" {
  name        = "${var.cy_child_org}-cycloid"
  description = "Repo for ${var.cy_child_org} IDP organization"

  visibility = "private"
  auto_init  = true
}

resource "github_branch" "stacks" {
  repository = github_repository.idp-git.name
  branch     = "stacks"
}

resource "github_branch" "config" {
  repository = github_repository.idp-git.name
  branch     = "config"
}

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "idp-git" {
  title      = "${var.cy_child_org}-cycloid"
  repository = github_repository.idp-git.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}

resource "cycloid_credential" "git-ssh" {
  name                   = "${var.cy_child_org}-cycloid-git-ssh"
  description            = "SSH Key Pair used to access stacks and config Cycloid GitHub repository for ${var.cy_child_org} IDP organization."
  path                   = "${var.cy_child_org}-cycloid-git-ssh"
  canonical              = "${var.cy_child_org}-cycloid-git-ssh"
  organization_canonical = cycloid_organization.child_org.organization_canonical

  type = "ssh"
  body = {
    ssh_key = chomp(tls_private_key.github_generated_key.private_key_openssh)
  }
}

#
# Stacks and Config
#
resource "cycloid_catalog_repository" "idp_repo" {
  name                   = "Internal Developer Portal Catalog Repository"
  url                    = var.github_url_idp
  branch                 = var.github_branch_idp
  organization_canonical = cycloid_organization.child_org.organization_canonical
}

resource "cycloid_catalog_repository" "catalog_repo" {
  name                   = "Your Catalog Repository"
  url                    = github_repository.idp-git.ssh_clone_url
  branch                 = github_branch.stacks.branch
  credential_canonical   = cycloid_credential.git-ssh.canonical
  organization_canonical = cycloid_organization.child_org.organization_canonical

  depends_on = [
    cycloid_credential.git-ssh
  ]
}

resource "cycloid_config_repository" "config_repo" {
  name                   = "Your Config Repository"
  url                    = github_repository.idp-git.ssh_clone_url
  branch                 = github_branch.config.branch
  credential_canonical   = cycloid_credential.git-ssh.canonical
  default                = true
  organization_canonical = cycloid_organization.child_org.organization_canonical

  depends_on = [
    cycloid_credential.git-ssh
  ]
}