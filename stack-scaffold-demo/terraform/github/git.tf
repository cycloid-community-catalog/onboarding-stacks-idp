resource "github_repository" "scaffold" {
  name        = var.github_repo_name
  description = var.github_repo_description != "" ? var.github_repo_description : "Repo for ${var.cy_project}-${var.cy_env} project"

  visibility = var.github_repo_visibility
  auto_init  = var.github_auto_init
}

# resource "github_branch" "develop" {
#   repository = github_repository.scaffold.name
#   branch     = "develop"
# }

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "scaffold" {
  title      = "${var.cy_project}-${var.cy_env}"
  repository = github_repository.scaffold.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}