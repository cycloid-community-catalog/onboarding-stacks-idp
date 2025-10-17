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

resource "cycloid_credential" "ssh_key" {
  name                   = "${var.cy_child_org}-cycloid-git-ssh"
  description            = "SSH Key Pair used to access stacks and config Cycloid GitHub repository for ${var.cy_child_org} IDP organization."
  path                   = "${var.cy_child_org}-cycloid-git-ssh"
  canonical              = "${var.cy_child_org}-cycloid-git-ssh"

  type = "ssh"
  body = {
    ssh_key = chomp(tls_private_key.github_generated_key.private_key_openssh)
  }
}