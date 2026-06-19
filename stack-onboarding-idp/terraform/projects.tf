#
# Projects
#

resource "cycloid_project" "infrastructure" {
  organization = var.cy_child_org_canonical
  canonical    = "infrastructure"
  name         = "Infrastructure"
  owner        = var.project_owner
}

resource "cycloid_project" "application" {
  organization = var.cy_child_org_canonical
  canonical    = "application"
  name         = "Application"
  owner        = var.project_owner
}
