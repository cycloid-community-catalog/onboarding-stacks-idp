# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "azure_cred" {
  description = "Azure credentials"
  sensitive   = true
}

variable "azuredevops_org" {
  type        = string
  description = "Azure DevOps organization"
}

variable "azuredevops_project" {
  type        = string
  description = "Azure DevOps project"
}

variable "azuredevops_repo_name" {
  type        = string
  description = "Azure DevOps repository name"
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
