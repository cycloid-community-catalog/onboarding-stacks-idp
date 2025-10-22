# Cycloid variables
variable "cy_org" {}
variable "cy_project" {}
variable "cy_env" {}
variable "cy_component" {}

variable "cy_child_org_canonical" {
  description = "Cycloid child organization canonical name"
}

# Members
variable "team_members_infrastructure" {
  description = "Infrastructure team members to invite to the new software project."
  type        = list(string)
}

variable "team_members_application" {
  description = "Application team members to invite to the new software project."
  type        = list(string)
}

variable "team_members_integration" {
  description = "Integration team members to invite to the new software project."
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