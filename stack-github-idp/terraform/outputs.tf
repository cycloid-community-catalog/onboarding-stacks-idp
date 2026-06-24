output "git_ssh_url" {
  description = "SSH URL for the GitHub repository"
  value       = github_repository.scaffold.ssh_clone_url
}

output "git_http_url" {
  description = "HTTPS URL for the GitHub repository (no credentials embedded)"
  value       = github_repository.scaffold.http_clone_url
}

output "git_https_credential_canonical" {
  description = "Cycloid credential canonical for HTTPS git clone (basic_auth: x-access-token + PAT)"
  value       = module.cycloid-cred-git.git_https_credential_canonical
}

output "repository_name" {
  description = "Name of the created GitHub repository"
  value       = github_repository.scaffold.name
}

output "repository_id" {
  description = "ID of the created GitHub repository"
  value       = github_repository.scaffold.node_id
}

output "ssh_private_key" {
  description = "SSH private key for repository access"
  value       = tls_private_key.github_generated_key.private_key_openssh
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key for repository access"
  value       = tls_private_key.github_generated_key.public_key_openssh
}