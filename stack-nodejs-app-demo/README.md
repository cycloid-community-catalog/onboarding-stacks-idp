# NodeJS Application Stack Demo

This repository contains the automation code for deploying and managing Node.js applications on various cloud providers using Terraform and Ansible. The stack is designed to be deployed through Cycloid's platform.

## Overview

This automation creates and manages Node.js application deployments with the following features:
- Multi-cloud support (AWS, Azure, VMware, Outscale, Ionos)
- Automated container deployment using Docker
- Configurable application settings and environment variables
- Network configuration with customizable security groups
- Integration with Cycloid's platform for deployment and management

## Prerequisites

- Access to a cloud provider (AWS, Azure, VMware, Outscale, or Ionos)
- Git repository access for application code
- Cycloid platform access

## Configuration

The stack can be configured through the following parameters:

### Application Configuration
- `git_url`: Git repository URL for application code (SSH format)
- `git_branch`: Git branch or release tag to deploy
- `git_path`: Path to the application in the repository (default: ".")
- `git_ssh_key`: SSH key for Git repository access
- `app_image`: Container image name
- `app_tag`: Container image tag
- `app_port`: Application port (default: 8080)

### Cloud Provider Configuration
- `aws_region`: AWS region for resource deployment (if using AWS)
- `vm_instance_type`: Instance type for the VM
- `vm_disk_size`: Disk size in GB
- `vm_ports_in`: List of ingress TCP ports (default: [22, 80, 443, 3000, 8080])

### Day-2 Operations
- `hosts_service`: Service to restart on the instance
- `hosts_package`: Package to install on the instance
- `hosts_user`: User to create on the instance

## Deployment

The stack is designed to be deployed through Cycloid's platform. The deployment process is automated through the pipeline configuration in the `pipeline/` directory.

### Pipeline Jobs

- `build-and-push`: Builds and pushes the application container image
  - Fetches application code from Git repository
  - Builds Docker image using the application's Dockerfile
  - Pushes the image to the configured container registry
- `deploy-infra`: Deploys the infrastructure using Terraform
- `deploy-app`: Deploys and runs the Node.js application container on the infrastructure using Ansible
- `destroy-infra`: Destroys the infrastructure

## Components

### Infrastructure
- Virtual machine deployment with configurable specifications
- Network security configuration
- Docker installation and configuration

### Application Deployment
- Docker container deployment
- Application configuration management
- Service management
- User management

## Directory Structure

- `terraform/`: Contains Terraform configuration files for each cloud provider
  - `aws/`: AWS-specific configurations
  - `azure/`: Azure-specific configurations
  - `vmware/`: VMware-specific configurations
  - `outscale/`: Outscale-specific configurations
  - `ionos/`: Ionos-specific configurations
- `ansible/`: Contains Ansible playbooks and configurations
  - `environments/`: Environment-specific configurations
  - `site.yml`: Main playbook for application deployment
- `pipeline/`: Contains pipeline configuration for Cycloid
- `.cycloid.yml`: Cycloid project configuration
- `.forms.yml`: Forms configuration for Cycloid

## Security

- SSH keys are managed securely through Cycloid's platform
- Network access is restricted to specified ports
- Docker container security best practices
- Secure credential management

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

