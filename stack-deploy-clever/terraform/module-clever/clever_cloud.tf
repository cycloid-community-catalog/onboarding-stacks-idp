# Network Group
resource "clevercloud_networkgroup" "app_cy_network_group" {
  name        = var.network_group_name
  description = var.network_group_description
  tags        = var.network_group_tags
}

# PostgreSQL Database
resource "clevercloud_postgresql" "app_postgresql" {
  name   = var.postgresql_name
  region = var.tf_region
  plan   = var.postgresql_plan

  networkgroups = [
    {
      fqdn            = local.postgresql_fqdn
      networkgroup_id = clevercloud_networkgroup.app_cy_network_group.id
    }
  ]
}

# Docker application: Clever clones app_git_repository at git_ref, then runs docker build (Dockerfile in repo).
# On first create, the Terraform provider pushes that tree to Clever’s deploy remote (GitDeploy).
resource "clevercloud_docker" "app_docker" {
  name               = var.docker_name
  region             = var.tf_region
  min_instance_count = var.docker_min_instance_count
  max_instance_count = var.docker_max_instance_count
  smallest_flavor    = var.docker_smallest_flavor
  biggest_flavor     = var.docker_biggest_flavor

  container_port = var.docker_exposed_http_port

  app_folder = local.app_git_folder_trimmed != "" ? local.app_git_folder_trimmed : null
  dockerfile = var.app_dockerfile_name != "" && var.app_dockerfile_name != "Dockerfile" ? var.app_dockerfile_name : null

  deployment {
    repository           = var.app_git_repository
    commit               = local.git_ref
    authentication_basic = local.git_authentication_basic
  }

  networkgroups = [
    {
      fqdn            = "${local.app_prefix}.m.${clevercloud_networkgroup.app_cy_network_group.id}.cc-ng.cloud"
      networkgroup_id = clevercloud_networkgroup.app_cy_network_group.id
    }
  ]

  vhosts = [{
    fqdn       = local.app_fqdn
    path_begin = var.docker_path_begin
  }]

  dependencies = [clevercloud_postgresql.app_postgresql.id]

  environment = {
    DATABASE_URL = clevercloud_postgresql.app_postgresql.uri
  }
}
