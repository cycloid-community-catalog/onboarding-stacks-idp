# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "git_ssh_key" {
  description = "SSH private key allowing access to a code git repository."
  sensitive = true
}