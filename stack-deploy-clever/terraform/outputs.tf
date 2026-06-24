output "network_group_id" {
  description = "The ID of the network group."
  value       = module.clever_cloud.network_group_id
}

output "docker_application_id" {
  description = "The ID of the Docker application."
  value       = module.clever_cloud.docker_application_id
}

output "application_url" {
  description = "Public HTTPS URL of the Docker application (e.g. org-component-env-project.cleverapps.io)."
  value       = module.clever_cloud.application_url
}