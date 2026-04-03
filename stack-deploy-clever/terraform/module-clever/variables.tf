locals {
  app_fqdn        = "${var.app_subdomain}.cleverapps.io"
  postgresql_fqdn = "${local.app_prefix}.services.clever-cloud.com"
  app_prefix      = "${var.cy_component}-${var.cy_environment}-${var.cy_project}"

  docker_registry_url      = (var.dockerhub_registry_url != null && var.dockerhub_registry_url != "") ? var.dockerhub_registry_url : null
  docker_registry_user       = (var.dockerhub_username != null && var.dockerhub_username != "") ? var.dockerhub_username : null
  docker_registry_password   = (var.dockerhub_password != null && var.dockerhub_password != "") ? var.dockerhub_password : null
  resolved_git_auth_basic    = (var.app_git_auth_basic != null && trimspace(var.app_git_auth_basic) != "") ? var.app_git_auth_basic : null

  git_ref = trimspace(var.app_release_tag) != "" ? (
    startswith(trimspace(var.app_release_tag), "refs/") ? trimspace(var.app_release_tag) : "refs/tags/${trimspace(var.app_release_tag)}"
    ) : (
    startswith(trimspace(var.app_git_branch), "refs/") ? trimspace(var.app_git_branch) : "refs/heads/${trimspace(var.app_git_branch)}"
  )

  app_git_folder_trimmed = trimspace(var.app_git_folder)
}

# =============================================================================
# General
# =============================================================================

variable "tf_region" {
  description = "Clever Cloud region"
  type        = string
  default     = "grahds"
  # dropdown : ["par", "rbx", "grahds"]
  # default: "grahds"
}

variable "app_subdomain" {
  description = "Shared FQDN for the application vhosts."
  type        = string
  default     = "my-digit-b4-cy-test"
  # simple_text
  # required
}


# =============================================================================
# Network Group
# =============================================================================

variable "network_group_name" {
  description = "Name of the network group."
  type        = string
  default     = "ng-cy-test"
  # required
}

variable "network_group_description" {
  description = "Description for the network group."
  type        = string
  default     = "Network Group for cycloid test"
  # default: ""
}

variable "network_group_tags" {
  description = "Tags for the network group."
  type        = list(string)
  default     = ["test"]
  # auto_complete with multiselect: true and suggest tag names
  # default: []
}

# =============================================================================
# PostgreSQL
# =============================================================================

variable "postgresql_name" {
  description = "Name of the PostgreSQL database."
  type        = string
  default     = "cy-test-db"
  # required
}

variable "postgresql_plan" {
  description = "PostgreSQL plan (e.g. xxs_sml, s_sml, m_sml)."
  type        = string
  default     = "xxs_sml"
  # dropdown with values: ["xxs_sml", "s_sml", "m_sml"]
  # default: "xxs_sml"
}

# =============================================================================
# Docker Backend
# =============================================================================

variable "docker_name" {
  description = "Name of the Docker backend application."
  type        = string
  default     = "docker_cy_test"
  # simple_text
  # required
}

variable "docker_min_instance_count" {
  description = "Minimum number of Docker backend instances."
  type        = number
  default     = 1
  # slider_list with values [1, 4]
  # default: 1
}

variable "docker_max_instance_count" {
  description = "Maximum number of Docker backend instances."
  type        = number
  default     = 2
  # slider_list with values [1, 4]
  # default: 2
}

variable "docker_smallest_flavor" {
  description = "Smallest instance flavor for the Docker backend."
  type        = string
  default     = "XS"
  # dropdown value: ["XS", "S", "M"]
  # default: "XS"
}

variable "docker_biggest_flavor" {
  description = "Biggest instance flavor for the Docker backend."
  type        = string
  default     = "M"
  # dropdown value: ["XS", "S", "M"]
  # default: "XS"
}

variable "docker_path_begin" {
  description = "Path prefix for the Docker backend vhost."
  type        = string
  default     = "/api"
  # simple_text
  # required
}

variable "docker_exposed_http_port" {
  description = "HTTP port exposed by the Docker container (e.g. 80 for nginx, 8080 for Spring Boot)."
  type        = number
  default     = 80
  # number
  # required
}

variable "app_git_repository" {
  description = "HTTPS URL of the Git repository that contains the Dockerfile (Clever clones it on deploy)."
  type        = string
}

variable "app_git_branch" {
  description = "Branch to deploy when app_release_tag is empty (e.g. main)."
  type        = string
  default     = "main"
}

variable "app_release_tag" {
  description = "Optional Git tag; when set, deploy refs/tags/<tag>. When empty, use app_git_branch."
  type        = string
  default     = ""
}

variable "app_git_folder" {
  description = "Optional subfolder under the repo root where the Dockerfile lives (Clever app_folder)."
  type        = string
  default     = ""
}

variable "app_dockerfile_name" {
  description = "Dockerfile name relative to app folder (defaults to Dockerfile)."
  type        = string
  default     = "Dockerfile"
}

variable "app_git_auth_basic" {
  description = "Optional HTTP basic auth for private Git HTTPS clone: \"username:token_or_password\" (e.g. GitHub PAT)."
  type        = string
  sensitive   = true
  default     = null
}

variable "dockerhub_registry_url" {
  description = "Optional private registry API URL. For private Docker Hub images use https://index.docker.io/v1/"
  type        = string
  default     = null
}

variable "dockerhub_username" {
  description = "Optional Docker Hub username (private images)."
  type        = string
  default     = null
}

variable "dockerhub_password" {
  description = "Optional Docker Hub password or access token (private images)."
  type        = string
  sensitive   = true
  default     = null
}

## Don't fill those variables in stackforms
variable "cy_organization" {
  type = string
}

variable "cy_project" {
  type = string
}

variable "cy_environment" {
  type = string
}

variable "cy_component" {
  type = string
}
