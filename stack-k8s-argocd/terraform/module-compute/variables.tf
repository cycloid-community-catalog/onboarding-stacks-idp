# Cycloid
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

# AWS
variable "aws_region" {
  description = "AWS region where to deploy the resources."
}

# Infra
variable "vm_instance_type" {
  description = "Instance type to deploy."
  default     = "t3a.small"
}

variable "vm_disk_size" {
  description = "Disk size for the instance (Go)"
  default = "20"
}

variable "vm_ports_in" {
  description = "Ingress TCP ports allowed from the internet.)"
  default = ["80", "443", "6443", "8443", "8080", "8081"]
}

variable "vm_os_user" {
  description = "Admin username to connect to instance via SSH. Set to 'admin' because we use debian OS."
  default     = "admin"
}

variable "vm_aws_route53_zone" {
  description = "Route53 Hosted Zone (e.g. cycloid-demo.com) where DNS records will be created"
  default     = "cycloid-demo.com"
}

variable "res_selector" {
  description = "Whether to create a new VPC or select an existing one"
}

variable "vpc_id_inventory" {
  description = "VPC where to deploy the resources"
}

variable "vpc_id_manual" {
  description = "VPC where to deploy the resources"
}

variable "argocd_version" {
  description = "ArgoCD version to deploy"
  default     = "v3.0.11"
}

variable "git_ssh_url" {
  description = "SSH URL to access the Git repository"
}

variable "git_private_key" {
  description = "Private key to access the Git repository"
  sensitive   = true
}