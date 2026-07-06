#
# Cycloid GitHub repository
#
resource "github_repository" "idp-git" {
  name        = "${var.cy_child_org_canonical}-cycloid"
  description = "Repo for ${var.cy_child_org_canonical} IDP organization"

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

data "cycloid_credential" "git-ssh" {
  organization = var.cy_child_org_canonical
  canonical = "${var.cy_child_org_canonical}-cycloid-git-ssh"
}

data "tls_public_key" "public_key_from_private" {
  private_key_openssh = data.cycloid_credential.git-ssh.body.ssh_key
}

resource "github_repository_deploy_key" "idp-git" {
  title      = "${var.cy_child_org_canonical}-cycloid"
  repository = github_repository.idp-git.name
  key        = data.tls_public_key.public_key_from_private.public_key_openssh
  read_only  = false
}

#
# Stacks and Config
#
resource "cycloid_config_repository" "config_repo" {
  name                   = "my-config"
  url                    = github_repository.idp-git.ssh_clone_url
  branch                 = github_branch.config.branch
  credential_canonical   = data.cycloid_credential.git-ssh.canonical
  default                = true
  organization_canonical = var.cy_child_org_canonical

  depends_on = [
    github_repository_deploy_key.idp-git,
    github_branch.config,
  ]
}

resource "cycloid_catalog_repository" "my_stacks" {
  name                   = "my-stacks"
  url                    = github_repository.idp-git.ssh_clone_url
  branch                 = github_branch.stacks.branch
  credential_canonical   = data.cycloid_credential.git-ssh.canonical
  #owner                  = var.project_owner
  organization_canonical = var.cy_child_org_canonical

  depends_on = [
    github_repository_deploy_key.idp-git,
    github_branch.stacks,
  ]
}

resource "cycloid_catalog_repository" "idp_stacks" {
  name                   = "idp-stacks"
  url                    = var.github_url_idp
  branch                 = var.github_branch_idp
  #owner                  = var.project_owner
  organization_canonical = var.cy_child_org_canonical
}

resource "cycloid_catalog_repository" "cmp_stacks" {
  name                   = "onboarding-stacks-cmp"
  url                    = var.github_url_cmp
  branch                 = var.github_branch_cmp
  #owner                  = var.project_owner
  organization_canonical = var.cy_child_org_canonical
}