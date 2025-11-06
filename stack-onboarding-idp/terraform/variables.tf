# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "cy_child_org_canonical" {
  description = "Cycloid child organization canonical name"
}

# AWS variables
variable "aws_cred" {
  description = "Contains AWS access_key and secret_key"
}
variable "aws_region" {
  description = "AWS region where to create servers."
  default     = "eu-west-1"
}

# Docker Hub credentials
variable "dockerhub_cred" {
  description = "Docker Hub credentials for the new software project."
  sensitive   = true
}

# Cloud Provider Credentials
variable "aws_cred_infra" {
  description = "AWS credentials for Terraform."
  sensitive   = true
}

variable "azure_cred_infra" {
  description = "Azure credentials for Terraform."
  sensitive   = true
}

# GitHub variables
variable "github_pat" {
  description = "GitHub Personal Access Token allowing to create the new ArgoCD repository. The token must be in the format of 'ghp_<token>', stored in the password field and be created with the 'repo' scope."
}

variable "github_url_idp" {
  description = "GitHub URL for the IDP stacks"
  default     = "https://github.com/cycloid-community-catalog/onboarding-stacks-idp.git"
}

variable "github_branch_idp" {
  description = "GitHub branch for the IDP stacks"
  default     = "master"
}

# Members
# variable "team_members_infrastructure" {
#   description = "Infrastructure team members to invite to the new software project."
#   type        = list(string)
# }

# variable "team_members_application" {
#   description = "Application team members to invite to the new software project."
#   type        = list(string)
# }

# variable "team_members_integration" {
#   description = "Integration team members to invite to the new software project."
#   type        = list(string)
# }

variable "project_owner" {
  description = "Project owner to set for the new project resources."
  type        = string
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