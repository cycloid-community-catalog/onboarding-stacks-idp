resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.argocd_version
  timeout    = "1500"

  namespace        = kubernetes_namespace.argocd.id
  create_namespace = true

  set = [
    {
      name  = "global.domain"
      value = "${var.cy_org}-${var.cy_project}-${var.cy_env}-argocd.${var.kubernetes_ip_address}.nip.io"
    },
    {
      name  = "server.ingress.enabled"
      value = true
    },
    {
      name  = "server.ingress.ingressClassName"
      value = "nginx"
    },
    {
      name  = "configs.params.server.insecure"
      value = true
    },
    {
      name  = "configs.secret.argocdServerAdminPassword"
      value = random_password.argocd.result
    },
    {
      name  = "configs.repositories.private-repo.url"
      value = var.argocd_git_url
    },
    {
      name  = "configs.credentialTemplates.private-repo.url"
      value = var.argocd_git_url
    },
    {
      name  = "configs.credentialTemplates.private-repo.sshPrivateKey"
      value = var.argocd_git_key
    }
  ]
}

data "kubernetes_service" "argocd_server" {
 metadata {
   name      = "argocd-server"
   namespace = helm_release.argocd.namespace
 }
}

resource "random_password" "argocd" {
  length           = 16
  special          = false
}

resource "cycloid_credential" "argocd" {
  name                   = "${var.cy_project}-${var.cy_env}-admin-argocd"
  description            = "ArgoCD Admin password."
  path                   = "${var.cy_project}-${var.cy_env}-admin-argocd"
  canonical              = "${var.cy_project}-${var.cy_env}-admin-argocd"

  type = "basic_auth"
  body = {
    username = "admin"
    password = random_password.argocd.result
  }
}