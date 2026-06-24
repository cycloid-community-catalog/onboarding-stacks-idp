output "network_group_id" {
  description = "The ID of the network group."
  value       = clevercloud_networkgroup.app_cy_network_group.id
}

output "docker_application_id" {
  description = "The ID of the Docker application."
  value       = clevercloud_docker.app_docker.id
}

output "application_url" {
  description = "Public HTTPS URL of the Docker application (e.g. org-component-env-project.cleverapps.io)."
  value       = "https://${local.app_fqdn}"
}
