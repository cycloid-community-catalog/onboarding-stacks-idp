# GitLab Project
resource "gitlab_project" "scaffold" {
  name                 = var.gitlab_repo_name
  description          = var.gitlab_repo_description != "" ? var.gitlab_repo_description : "Repo for ${var.cy_project}-${var.cy_env} project"
  namespace_id         = data.gitlab_group.namespace.id
  visibility_level     = var.gitlab_repo_visibility
  initialize_with_readme = false
}

# Get GitLab namespace/group
data "gitlab_group" "namespace" {
  full_path = var.gitlab_namespace
}

# GitLab SSH Key
resource "tls_private_key" "gitlab_generated_key" {
  algorithm = "ED25519"
}

resource "gitlab_deploy_key" "scaffold" {
  project  = gitlab_project.scaffold.id
  title    = "${var.cy_project}-${var.cy_env}"
  key      = tls_private_key.gitlab_generated_key.public_key_openssh
  can_push = true
}