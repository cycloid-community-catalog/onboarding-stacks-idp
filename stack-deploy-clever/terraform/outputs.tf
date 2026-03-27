output "network_group_id" {
  description = "The ID of the network group."
  value       = module.clever_cloud.network_group_id
}

output "docker_application_id" {
  description = "The ID of the Docker application."
  value       = module.clever_cloud.docker_application_id
}

output "postgresql_id" {
  description = "The ID of the PostgreSQL add-on."
  value       = module.clever_cloud.postgresql_id
}

output "postgresql_uri" {
  description = "PostgreSQL connection URI (sensitive)."
  value       = module.clever_cloud.postgresql_uri
  sensitive   = true
}