resource "cycloid_credential" "git-ssh" {
  name                   = "${var.cy_project}-app-git-ssh"
  description            = "SSH private key allowing access to a code git repository."
  organization_canonical = var.cy_org
  path                   = "${var.cy_project}-app-git-ssh"
  canonical              = "${var.cy_project}-app-git-ssh"

  type = "ssh"
  body = {
    ssh_key = chomp(var.git_ssh_key)
  }
}

resource "cycloid_credential" "git-https" {
  name                   = "${var.cy_project}-app-git-https"
  description            = "GitHub PAT for HTTPS clone of the application repository."
  organization_canonical = var.cy_org
  path                   = "${var.cy_project}-app-git-https"
  canonical              = "${var.cy_project}-app-git-https"

  type = "basic_auth"
  body = {
    username = var.git_https_username
    password = var.git_https_token
  }
}