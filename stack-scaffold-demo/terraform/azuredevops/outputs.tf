output "git_ssh_url" {
  description = "SSH URL for the GitHub repository"
  value       = azuredevops_git_repository.scaffold_repository.ssh_url
}

output "git_http_url" {
  description = "HTTP URL for the GitHub repository"
  value       = azuredevops_git_repository.scaffold_repository.remote_url
}

output "repository_name" {
  description = "Name of the created GitHub repository"
  value       = azuredevops_git_repository.scaffold_repository.name
}

output "repository_id" {
  description = "ID of the created GitHub repository"
  value       = azuredevops_git_repository.scaffold_repository.node_id
}

output "ssh_private_key" {
  description = "SSH private key for repository access"
  value       = tls_private_key.azuredevops_generated_key.private_key_openssh
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key for repository access"
  value       = tls_private_key.azuredevops_generated_key.public_key_openssh
}