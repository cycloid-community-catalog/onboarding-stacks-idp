# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  sensitive   = true
}

variable "github_org" {
  type        = string
  description = "GitHub organization or username where the repository will be created"
}

variable "github_repo_name" {
  type        = string
  description = "Name of the GitHub repository to create"
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

variable "github_auto_init" {
  type        = bool
  description = "Initialize the repository with a README file"
  default     = false
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
