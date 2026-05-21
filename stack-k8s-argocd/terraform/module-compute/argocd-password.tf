resource "random_password" "argocd_admin_password" {
  length  = 12
  special = false
}

resource "cycloid_credential" "argocd_admin_password" {
  name                   = "argocd-admin-password"
  description            = "ArgoCD admin password."
  path                   = "argocd-admin-password"
  canonical              = "argocd-admin-password"

  type = "basic_auth"
  body = {
    username = "admin"
    password = local.argocd_admin_password
  }
}

locals {
  # argocd_admin_password = random_password.argocd_admin_password.result
  argocd_admin_password = "cycloid"
}