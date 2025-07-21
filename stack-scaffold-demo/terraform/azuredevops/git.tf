resource "azuredevops_project" "scaffold_project" {
  name               = var.azuredevops_project
  visibility         = "private"
  version_control    = "Git"
}

resource "azuredevops_git_repository" "scaffold_repository" {
  project_id = azuredevops_project.scaffold_project.id
  name       = var.azuredevops_repo_name
  initialization {
    init_type = "Clean"
  }
}

resource "tls_private_key" "azuredevops_generated_key" {
  algorithm   = "ED25519"
}

resource "azuredevops_git_repository_deploy_key" "scaffold" {
  project_id = azuredevops_project.scaffold_project.id
  repository_id = azuredevops_git_repository.scaffold_repository.id
  title = "Scaffold Deploy Key"
  key = tls_private_key.azuredevops_generated_key.public_key_openssh
  read_only = false
}

resource "azuredevops_serviceendpoint_ssh" "scaffold" {
  project_id            = azuredevops_project.scaffold_project.id
  service_endpoint_name = "Scaffold SSH"
  host                  = tls_private_key.azuredevops_generated_key.public_key_openssh
  username              = "git"
  description           = "Managed by Terraform"
}
