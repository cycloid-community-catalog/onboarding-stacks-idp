module "clever_cloud" {
  source = "./module-clever"

  cy_organization = "($ .organization $)"
  cy_project      = "($ .project $)"
  cy_environment  = "($ .environment $)"
  cy_component    = "($ .component $)"

  tf_region                 = var.tf_region
  app_subdomain             = var.app_subdomain

  network_group_name        = var.network_group_name
  network_group_description = var.network_group_description
  network_group_tags        = var.network_group_tags

  postgresql_name           = var.postgresql_name
  postgresql_plan           = var.postgresql_plan

  docker_name               = var.docker_name
  docker_min_instance_count = var.docker_min_instance_count
  docker_max_instance_count = var.docker_max_instance_count
  docker_smallest_flavor    = var.docker_smallest_flavor
  docker_biggest_flavor     = var.docker_biggest_flavor
  docker_path_begin         = var.docker_path_begin
  docker_exposed_http_port  = var.docker_exposed_http_port
  docker_image              = var.docker_image
  dockerhub_registry_url    = var.dockerhub_registry_url
  dockerhub_username        = var.dockerhub_username
  dockerhub_password        = var.dockerhub_password
}