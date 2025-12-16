# Cycloid
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

# IONOS
variable "ionos_region" {
  description = "The IONOS region where to deploy the infrastructure."
}

variable "ionos_cube" {
  description = "The IONOS cube configuration to deploy."
}

variable "ionos_lan" {
  description = "The network where to deploy the infrastructure."
}

variable "ionos_private_network" {
  description = "Whether to connect the instance to a IONOS private network."
}
variable "ionos_username" {
  description = "The IONOS admin username on the instance."
  default = "root"
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