resource "github_repository" "argocd" {
  name        = "${var.cy_project}-argocd"
  description = "ArgoCD repo managed by Cycloid in ${var.cy_project} project in ${var.cy_org} org"

  visibility = "private"
  auto_init  = true
}

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "argocd" {
  title      = "${var.cy_project}"
  repository = github_repository.argocd.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}

resource "cycloid_credential" "ssh_key" {
  name                   = "${var.cy_project}-${var.cy_env}-git-argocd"
  description            = "SSH Key Pair used to access ArgoCD GitHub repo."
  path                   = "${var.cy_project}-${var.cy_env}-git-argocd"
  canonical              = "${var.cy_project}-${var.cy_env}-git-argocd"

  type = "ssh"
  body = {
    ssh_key = chomp(tls_private_key.github_generated_key.private_key_openssh)
  }
}