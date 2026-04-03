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
  description = "HTTPS URL of the application Git repository (contains Dockerfile)."
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

variable "app_git_auth_basic" {
  type      = string
  sensitive = true
  default   = null
}

variable "dockerhub_registry_url" {
  type    = string
  default = null
}

variable "dockerhub_username" {
  type    = string
  default = null
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
  default   = null
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
