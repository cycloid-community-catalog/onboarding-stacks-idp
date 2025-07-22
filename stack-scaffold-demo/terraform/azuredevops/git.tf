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

resource "null_resource" "upload_ssh_key" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Basic $(echo -n ":${var.azuredevops_pat}" | base64)" \
        -d '{
              "keyData": "${replace(tls_private_key.azuredevops_generated_key.public_key_openssh, "\n", "\\n")}",
              "resource": "${var.azuredevops_repo_name}",
              "description": "Managed by Terraform"
            }' \
        https://dev.azure.com/${var.azuredevops_org}/_apis/ssh/publickeys?api-version=6.0-preview.1
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}