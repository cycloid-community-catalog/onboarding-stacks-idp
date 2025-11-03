resource "github_repository" "manifests" {
  name        = "${var.cy_org}-${var.cy_project}-${var.cy_env}-manifests"
  description = "ArgoCD Manifests repo managed by Cycloid in ${var.cy_project} project in ${var.cy_org} org"

  visibility = "private"
  auto_init  = true
}

resource "tls_private_key" "github_generated_key" {
  algorithm   = "ED25519"
}

resource "github_repository_deploy_key" "manifests" {
  title      = "${var.cy_org}-${var.cy_project}-${var.cy_env}-manifests"
  repository = github_repository.manifests.name
  key        = tls_private_key.github_generated_key.public_key_openssh
  read_only  = false
}

resource "cycloid_credential" "ssh_key" {
  name                   = "${var.cy_project}-${var.cy_env}-manifests-git-ssh"
  description            = "SSH Key Pair used to access ArgoCD Manifests GitHub repo."
  path                   = "${var.cy_project}-${var.cy_env}-manifests-git-ssh"
  canonical              = "${var.cy_project}-${var.cy_env}-manifests-git-ssh"

  type = "ssh"
  body = {
    ssh_key = chomp(tls_private_key.github_generated_key.private_key_openssh)
  }
}