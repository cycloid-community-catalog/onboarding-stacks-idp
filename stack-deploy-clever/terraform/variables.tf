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

variable "docker_image" {
  type    = string
  default = "nginx:alpine"
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
