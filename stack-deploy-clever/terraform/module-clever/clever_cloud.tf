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

# Docker Application — image from Docker Hub; PostgreSQL add-on linked via dependencies
resource "clevercloud_docker" "app_docker" {
  name               = var.docker_name
  region             = var.tf_region
  min_instance_count = var.docker_min_instance_count
  max_instance_count = var.docker_max_instance_count
  smallest_flavor    = var.docker_smallest_flavor
  biggest_flavor     = var.docker_biggest_flavor

  container_port = var.docker_exposed_http_port

  registry_url      = var.dockerhub_registry_url
  registry_user     = var.dockerhub_username
  registry_password = var.dockerhub_password

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
    # Docker image from Docker Hub
    CC_MOUNT_DOCKER_IMAGE = var.docker_image

    # Add-on endpoint (libpq / many runtimes)
    DATABASE_URL = clevercloud_postgresql.app_postgresql.uri
  }
}
