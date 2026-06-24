# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "git_ssh_key" {
  description = "SSH private key allowing access to a code git repository."
  sensitive   = true
}

variable "git_https_token" {
  description = "GitHub PAT used for HTTPS git clone (password; username is git_https_username)."
  sensitive   = true
}

variable "git_https_username" {
  description = "Username for HTTPS git clone with a GitHub PAT."
  type        = string
  default     = "x-access-token"
}