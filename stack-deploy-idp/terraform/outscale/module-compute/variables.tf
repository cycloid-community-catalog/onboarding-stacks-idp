# Cycloid
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

# Outscale
variable "outscale_region" {
  description = "The Outscale region where to deploy the infrastructure."
}

variable "outscale_username" {
  description = "The Outscale admin username on the instance."
  default = "outscale"
}

variable "outscale_cpu_gen" {
  description = "The Outscale CPU Generation to deploy."
}

variable "outscale_cpu" {
  description = "The number of CPU to deploy."
}

variable "outscale_mem" {
  description = "The amount of memory to deploy."
}

variable "outscale_net" {
  description = "The network where to deploy the infrastructure."
}

variable "outscale_private_network" {
  description = "Whether to connect to an Outscale private network."
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