output "git_ssh_url" {
  description = "SSH URL for the GitLab repository"
  value       = gitlab_project.scaffold.ssh_url_to_repo
}

output "git_http_url" {
  description = "HTTP URL for the GitLab repository"
  value       = gitlab_project.scaffold.http_url_to_repo
}

output "repository_name" {
  description = "Name of the created GitLab repository"
  value       = gitlab_project.scaffold.name
}

output "repository_id" {
  description = "ID of the created GitLab repository"
  value       = gitlab_project.scaffold.id
}

output "ssh_private_key" {
  description = "SSH private key for repository access"
  value       = tls_private_key.gitlab_generated_key.private_key_openssh
  sensitive   = true
}

output "ssh_public_key" {
  description = "SSH public key for repository access"
  value       = tls_private_key.gitlab_generated_key.public_key_openssh
} 