resource "github_repository" "scaffold" {
  name        = "${var.cy_org}-${var.cy_project}"
  description = var.github_repo_description != "" ? var.github_repo_description : "Repo for ${var.cy_project} project in ${var.cy_org}"

  visibility = var.github_repo_visibility
  auto_init  = true
}

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "scaffold" {
  title      = "${var.cy_org}-${var.cy_project}"
  repository = github_repository.scaffold.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}