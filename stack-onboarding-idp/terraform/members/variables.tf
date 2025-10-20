# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "cy_child_org_canonical" {
  description = "Cycloid child organization canonical name"
}

# AWS variables
variable "aws_region" {
  description = "AWS region where to create servers."
  default     = "eu-west-1"
}

# GitHub variables
variable "github_url_idp" {
  description = "GitHub URL for the IDP stacks"
  default     = "https://github.com/cycloid-community-catalog/onboarding-stacks-idp.git"
}

variable "github_branch_idp" {
  description = "GitHub branch for the IDP stacks"
  default     = "master"
}

# Members
variable "team_members_ccp_csp" {
  description = "CCP/CSP team members to invite to the new software project."
  type        = list(string)
}

variable "team_members_sods" {
  description = "SODS team members to invite to the new software project."
  type        = list(string)
}

variable "team_members_csds" {
  description = "CSDS team members to invite to the new software project."
  type        = list(string)
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