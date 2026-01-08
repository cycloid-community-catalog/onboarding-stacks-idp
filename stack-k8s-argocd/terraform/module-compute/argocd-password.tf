resource "random_password" "argocd_admin_password" {
  length  = 12
  special = false
}

resource "cycloid_credential" "argocd_admin_password" {
  name                   = "${var.cy_project}-${var.cy_env}-argocd-admin-password"
  description            = "ArgoCD admin password."
  path                   = "${var.cy_project}-${var.cy_env}-argocd-admin-password"
  canonical              = "${var.cy_project}-${var.cy_env}-argocd-admin-password"

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