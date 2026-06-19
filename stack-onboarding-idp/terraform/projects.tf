#
# Projects
#

resource "cycloid_project" "infrastructure" {
  organization       = var.cy_child_org_canonical
  canonical          = "infrastructure"
  name               = "Infrastructure"
  owner              = var.project_owner
  config_repository  = cycloid_config_repository.config_repo.canonical

  depends_on = [cycloid_config_repository.config_repo]
}

resource "cycloid_project" "application" {
  organization       = var.cy_child_org_canonical
  canonical          = "application"
  name               = "Application"
  owner              = var.project_owner
  config_repository  = cycloid_config_repository.config_repo.canonical

  depends_on = [cycloid_config_repository.config_repo]
}
