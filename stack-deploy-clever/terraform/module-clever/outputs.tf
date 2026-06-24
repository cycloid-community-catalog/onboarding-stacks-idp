output "network_group_id" {
  description = "The ID of the network group."
  value       = clevercloud_networkgroup.app_cy_network_group.id
}

output "docker_application_id" {
  description = "The ID of the Docker application."
  value       = clevercloud_docker.app_docker.id
}
