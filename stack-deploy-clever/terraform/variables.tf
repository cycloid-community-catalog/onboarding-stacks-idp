variable "tf_region" {
  type    = string
  default = "grahds"
}

variable "app_subdomain" {
  type = string
}

variable "network_group_name" {
  type = string
}

variable "network_group_description" {
  type    = string
  default = ""
}

variable "network_group_tags" {
  type    = list(string)
  default = []
}

variable "postgresql_name" {
  type = string
}

variable "postgresql_plan" {
  type    = string
  default = "xxs_sml"
}

variable "docker_name" {
  type = string
}

variable "docker_min_instance_count" {
  type    = number
  default = 1
}

variable "docker_max_instance_count" {
  type    = number
  default = 2
}

variable "docker_smallest_flavor" {
  type    = string
  default = "XS"
}

variable "docker_biggest_flavor" {
  type    = string
  default = "XS"
}

variable "docker_path_begin" {
  type = string
}

variable "docker_exposed_http_port" {
  type = number
}

variable "app_git_repository" {
  type        = string
  description = "HTTPS clone URL of the Git repo that contains the Dockerfile. The Clever Terraform provider does not support SSH (git@) or SSH deploy keys; use HTTPS and app_git_basic_auth with a token for private repos (e.g. GitHub: USER:PAT per Clever provider docs)."
  validation {
    condition     = can(regex("^https://", var.app_git_repository))
    error_message = "app_git_repository must be an https:// URL; the Clever provider clones over HTTPS with optional authentication_basic only."
  }
}

variable "app_git_branch" {
  type    = string
  default = "main"
}

variable "app_release_tag" {
  type    = string
  default = ""
}

variable "app_git_folder" {
  type    = string
  default = ""
}

variable "app_dockerfile_name" {
  type    = string
  default = "Dockerfile"
}

variable "app_git_basic_auth" {
  type        = any
  description = "Private Git over HTTPS: cy_cred basic_auth or \"user:token\" (e.g. GitHub fine-grained PAT as password). Maps to Clever deployment.authentication_basic. Not used for SSH; Clever’s provider has no SSH key field."
  sensitive   = true
  default     = null
}

variable "cy_org" {
  type = string
}

variable "cy_api_key" {
  type = string
}

variable "cy_api_url" {
  type    = string
  default = "https://http-api.cycloid.io"
}
