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

data "tls_public_key" "public_key_from_private" {
  private_key_openssh = var.github_private_key_openssh
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
# resource "cycloid_catalog_repository" "idp_repo" {
#   name                   = "Internal Developer Portal Catalog Repository"
#   url                    = var.github_url_idp
#   branch                 = var.github_branch_idp
#   owner                  = var.project_owner
#   organization_canonical = var.cy_child_org_canonical
# }

# resource "cycloid_catalog_repository" "catalog_repo" {
#   name                   = "Your Catalog Repository"
#   url                    = github_repository.idp-git.ssh_clone_url
#   branch                 = github_branch.stacks.branch
#   credential_canonical   = cycloid_credential.git-ssh.canonical
#   owner                  = var.project_owner
#   organization_canonical = var.cy_child_org_canonical
# }

# resource "cycloid_config_repository" "config_repo" {
#   name                   = "Your Config Repository"
#   url                    = github_repository.idp-git.ssh_clone_url
#   branch                 = github_branch.config.branch
#   credential_canonical   = cycloid_credential.git-ssh.canonical
#   default                = true
#   organization_canonical = var.cy_child_org_canonical
# }

# resource "tls_private_key" "github_generated_key" {
#   algorithm   = "ED25519"
# }

# resource "cycloid_credential" "git-ssh" {
#   name                   = "${var.cy_child_org_canonical}-cycloid-git-ssh"
#   description            = "SSH Key Pair used to access stacks and config Cycloid GitHub repository for ${var.cy_child_org_canonical} IDP organization."
#   path                   = "${var.cy_child_org_canonical}-cycloid-git-ssh"
#   canonical              = "${var.cy_child_org_canonical}-cycloid-git-ssh"
#   organization_canonical = var.cy_child_org_canonical

#   type = "ssh"
#   body = {
#     ssh_key = chomp(tls_private_key.github_generated_key.private_key_openssh)
#   }
# }