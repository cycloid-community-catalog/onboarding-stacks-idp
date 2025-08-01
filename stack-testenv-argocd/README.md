# Kubernetes Test Environment Stack

This repository contains the automation code for deploying and managing application test environments in a Kubernetes cluster. The stack is designed to be deployed through Cycloid's platform.

## Overview

This automation creates and manages application test environments with the following features:
- Automated container image building and pushing
- Kubernetes deployment with configurable replicas
- NGINX Ingress Controller integration
- Optional database integration (PostgreSQL/MySQL)
- Environment variable management
- Automatic DNS configuration using nip.io

## Prerequisites

- Access to a Kubernetes cluster
- Container registry access (Docker Hub or other)
- Git repository access for application code
- Cycloid platform access

## Configuration

The stack can be configured through the following parameters:

### Registry Configuration
- `registry_repository`: Container image repository path
- `registry_username`: Registry access username
- `registry_password`: Registry access password

### Application Configuration
- `git_url`: Git repository URL for application code
- `git_branch`: Git branch to deploy
- `git_ssh_key`: SSH key for Git repository access
- `app_replicas`: Number of application replicas (default: 3)
- `app_env_vars`: Additional environment variables for the application

### Database Configuration (Optional)
- `database_integration`: Enable database integration
- `database_env_var_name`: Environment variable name for database connection
- `database_engine`: Database type (postgresql/mysql)
- `database_cloud`: Cloud provider (aws/azure)
- `database_name`: Database name
- `database_aws`: AWS RDS endpoint (if using AWS)
- `database_azure`: Azure Database endpoint (if using Azure)

### Kubernetes Configuration
- `kubeconfig_content`: Kubernetes cluster access configuration

## Deployment

The stack is designed to be deployed through Cycloid's platform. The deployment process is automated through the pipeline configuration in the `pipeline/` directory.

### Pipeline Jobs

- `build-and-push`: Builds and pushes the application container image
- `deploy-app`: Deploys the application to Kubernetes
- `delete-app`: Removes the application from Kubernetes

## Components

### Application Deployment
- Kubernetes Deployment with configurable replicas
- Service for internal communication
- Ingress for external access
- ConfigMap for environment variables
- Automatic DNS configuration using nip.io

### Database Integration
- Support for PostgreSQL and MySQL
- Integration with AWS RDS and Azure Database
- Secure credential management
- Automatic connection string configuration

## Directory Structure

- `pipeline/`: Contains pipeline configuration for Cycloid
  - `pipeline.yml`: Main pipeline configuration
  - `variables.sample.yml`: Sample variables configuration
  - `manifest.yaml`: Kubernetes manifest template
- `.cycloid.yml`: Cycloid project configuration
- `.forms.yml`: Forms configuration for Cycloid

## Security

- Container registry credentials are managed securely
- Database credentials are stored in Cycloid vault
- Kubernetes access is managed through kubeconfig
- Environment variables are stored in Kubernetes ConfigMaps

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