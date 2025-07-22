# Cycloid
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "argocd_version" {
  description = "The version of ArgoCD to deploy."
}

variable "argocd_git_url" {
  description = "The URL of the ArgoCD git repo."
}

variable "argocd_git_key" {
  description = "The private SSH key to access the ArgoCD git repo."
}

# Tags
variable "extra_tags" {
  default = {}
}

locals {
  cycloid_tags = {
    cy_organization = var.cy_org
    cy_project      = var.cy_project
    cy_environment  = var.cy_env
    cy_component    = var.cy_component
  }
  merged_tags = merge(local.cycloid_tags, var.extra_tags)
}