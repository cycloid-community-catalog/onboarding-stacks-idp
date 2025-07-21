# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

# GitLab variables
variable "gitlab_pat" {
  description = "GitLab Personal Access Token"
  sensitive   = true
}

variable "gitlab_url" {
  type        = string
  description = "GitLab instance URL"
  default     = "https://gitlab.com"
}

variable "gitlab_namespace" {
  type        = string
  description = "GitLab group or namespace"
}

variable "gitlab_repo_name" {
  type        = string
  description = "GitLab repository name"
}

variable "gitlab_repo_description" {
  type        = string
  description = "GitLab repository description"
  default     = ""
}

variable "gitlab_repo_visibility" {
  type        = string
  description = "GitLab repository visibility"
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