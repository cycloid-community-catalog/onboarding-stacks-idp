# ArgoCD Stack

This repository contains the automation code for deploying and managing ArgoCD on a Kubernetes cluster. The stack is designed to be deployed through Cycloid's platform.

## Overview

This automation creates and manages an ArgoCD deployment with the following features:
- ArgoCD installation on Kubernetes using Helm
- GitHub repository creation for ArgoCD configuration
- NGINX Ingress Controller integration
- Secure credential management
- Integration with Cycloid's platform for deployment and management

## Prerequisites

- Access to a Kubernetes cluster
- GitHub account with appropriate credentials
- Cycloid platform access

## Configuration

The stack can be configured through the following parameters:

### ArgoCD Configuration
- `argocd_version`: Version of ArgoCD to deploy (default: 7.8.3)
- `argocd_git_url`: Git URL for ArgoCD configuration repository
- `argocd_git_key`: SSH private key for Git repository access

### GitHub Configuration
- `github_pat`: GitHub Personal Access Token for repository management

### Kubernetes Configuration
- `kubeconfig_content`: Kubernetes cluster access configuration

## Deployment

The stack is designed to be deployed through Cycloid's platform. The deployment process is automated through the pipeline configuration in the `pipeline/` directory.

### Pipeline Jobs

- `install-argocd`: Installs ArgoCD on the Kubernetes cluster
- `remove-argocd`: Removes ArgoCD from the Kubernetes cluster

## Components

### ArgoCD Infrastructure
- ArgoCD namespace creation
- Helm chart deployment
- Ingress configuration
- Secret management

### GitHub Repository
- Private repository creation
- Branch protection configuration
- Deploy key management
- SSH key generation and configuration

## Directory Structure

- `terraform/`: Contains Terraform configuration files
  - `module-argocd/`: ArgoCD module implementation
  - `main.tf`: Main Terraform configuration
  - `git.tf`: GitHub repository configuration
  - `variables.tf`: Variable definitions
- `pipeline/`: Contains pipeline configuration for Cycloid
  - `pipeline.yml`: Main pipeline configuration
  - `variables.sample.yml`: Sample variables configuration
- `.cycloid.yml`: Cycloid project configuration
- `.forms.yml`: Forms configuration for Cycloid

## Security

- GitHub credentials are managed securely through Cycloid's platform
- SSH keys are generated and stored securely
- ArgoCD admin password is managed through Cycloid credentials
- Repository access is controlled through deploy keys
- Secure credential management through Cycloid vault

## Maintenance

The stack maintenance can be performed in two ways:

1. **Code Management**: The stack is version controlled in a Git repository. You can:
   - Clone the repository
   - Make necessary modifications to the Terraform configurations
   - Submit changes through pull requests
   - Review and merge changes following your organization's Git workflow

2. **Form Customization**: The StackForms interface can be customized by:
   - Modifying the `.forms.yml` file to adjust form fields, validation rules, and UI elements
   - Adding or removing configuration options
   - Customizing the form layout and organization
   - Implementing conditional form fields based on user selections

## Support

For support, please contact your Cycloid administrator or refer to the Cycloid documentation.