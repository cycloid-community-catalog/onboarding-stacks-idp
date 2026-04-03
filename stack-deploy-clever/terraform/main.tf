module "clever_cloud" {
  source = "./module-clever"

  cy_organization = "($ .organization $)"
  cy_project      = "($ .project $)"
  cy_environment  = "($ .environment $)"
  cy_component    = "($ .component $)"

  tf_region             = var.tf_region
  app_subdomain         = var.app_subdomain
  app_git_repository    = var.app_git_repository
  app_git_branch        = var.app_git_branch
  app_release_tag       = var.app_release_tag
  app_git_folder        = var.app_git_folder
  app_dockerfile_name = var.app_dockerfile_name
  app_git_auth_basic  = var.app_git_auth_basic
  app_git_username    = var.app_git_username
  app_git_token       = var.app_git_token

  network_group_name        = var.network_group_name
  network_group_description = var.network_group_description
  network_group_tags        = var.network_group_tags

  postgresql_name = var.postgresql_name
  postgresql_plan = var.postgresql_plan

  docker_name               = var.docker_name
  docker_min_instance_count = var.docker_min_instance_count
  docker_max_instance_count = var.docker_max_instance_count
  docker_smallest_flavor    = var.docker_smallest_flavor
  docker_biggest_flavor     = var.docker_biggest_flavor
  docker_path_begin         = var.docker_path_begin
  docker_exposed_http_port  = var.docker_exposed_http_port

  dockerhub_registry_url = var.dockerhub_registry_url
  dockerhub_username     = var.dockerhub_username
  dockerhub_password     = var.dockerhub_password
}
