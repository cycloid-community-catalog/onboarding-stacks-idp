resource "github_repository" "scaffold" {
  name        = "${var.cy_org}-${var.cy_project}-${var.cy_env}-app"
  description = var.github_repo_description != "" ? var.github_repo_description : "Repo for ${var.cy_project} project in ${var.cy_org}"

  visibility = var.github_repo_visibility
  auto_init  = true
}

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "scaffold" {
  title      = "${var.cy_org}-${var.cy_project}-${var.cy_env}-app"
  repository = github_repository.scaffold.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}

resource "github_actions_variable" "org" {
  repository       = github_repository.scaffold.name
  variable_name    = "ORG"
  value            = var.cy_org
}

resource "github_actions_variable" "project" {
  repository       = github_repository.scaffold.name
  variable_name    = "PROJECT"
  value            = var.cy_project
}

resource "github_actions_variable" "env" {
  repository       = github_repository.scaffold.name
  variable_name    = "ENV"
  value            = var.cy_env
}

resource "github_actions_variable" "component" {
  repository       = github_repository.scaffold.name
  variable_name    = "COMPONENT"
  value            = var.cy_component
}

resource "github_actions_secret" "dockerhub_username" {
  repository       = github_repository.scaffold.name
  secret_name      = "DOCKERHUB_USERNAME"
  plaintext_value  = var.dockerhub_username
}

resource "github_actions_secret" "dockerhub_password" {
  repository       = github_repository.scaffold.name
  secret_name      = "DOCKERHUB_PASSWORD"
  plaintext_value  = var.dockerhub_password
}