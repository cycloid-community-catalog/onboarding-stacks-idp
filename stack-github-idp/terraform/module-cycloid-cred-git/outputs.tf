output "git_ssh_credential_canonical" {
  description = "Cycloid credential canonical for SSH git clone"
  value       = cycloid_credential.git-ssh.canonical
}

output "git_https_credential_canonical" {
  description = "Cycloid credential canonical for HTTPS git clone"
  value       = cycloid_credential.git-https.canonical
}
