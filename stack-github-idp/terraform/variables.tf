# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  sensitive   = true
}

variable "github_organization" {
  type        = string
  description = "GitHub organization or username where the repository will be created"
}

variable "github_repo_description" {
  type        = string
  description = "Description for the GitHub repository"
  default     = ""
}

variable "github_repo_visibility" {
  type        = string
  description = "Visibility level of the GitHub repository"
  default     = "private"
}

# Cycloid
variable "cy_api_url" {
  type        = string
  description = "Cycloid API endpoint"
}

variable "cy_api_key" {
  type        = string
  description = "Org JWT used for authentication"
  sensitive   = true
}

variable "dockerhub_username" {
  type        = string
  description = "DockerHub username"
  sensitive   = true
}

variable "dockerhub_token" {
  type        = string
  description = "DockerHub token"
  sensitive   = true
}