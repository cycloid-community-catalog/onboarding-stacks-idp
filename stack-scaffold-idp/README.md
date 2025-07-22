# Project Scaffolding Stack

This repository contains the automation code for creating and scaffolding new software projects using best practices and security rules. The stack is designed to be deployed through Cycloid's platform.

## Overview

This automation creates and scaffolds new projects with the following features:
- GitHub or GitLab repository creation and configuration
- Multiple development stack templates support
- Automated project structure setup
- Secure credential management
- Integration with Cycloid's platform for deployment and management

## Prerequisites

- GitHub or GitLab account with appropriate credentials
- Cycloid platform access

## Configuration

The stack can be configured through the following parameters:

### GitHub Configuration (Default Use Case)
- `github_pat`: GitHub Personal Access Token for repository management
- `git_source_url`: Source template repository URL
- `git_source_path`: Path to the template in the source repository
- `git_dest_url`: Destination repository URL
- `git_dest_key`: SSH key for destination repository access

### GitLab Configuration (GitLab Use Case)
- `gitlab_pat`: GitLab Personal Access Token with api scope
- `gitlab_url`: GitLab instance URL (e.g., https://gitlab.com)
- `gitlab_namespace`: GitLab group or namespace for the repository
- `gitlab_repo_name`: Name of the GitLab repository to create
- `gitlab_repo_description`: Description for the GitLab repository
- `gitlab_repo_visibility`: Repository visibility (private, internal, public)

### Development Stack Options
The following development stack templates are available:
- REST API using Express and Prisma Client
- REST API using Fastify and Prisma Client
- REST API using hapi and Prisma Client
- REST API using Koa and Prisma Client
- REST API using NestJS and Prisma Client
- Web app using Next.js and Prisma Client
- Fullstack app with Nuxt using Vue and Prisma Client
- Web app using React Router 7 and Prisma ORM
- Simple NodeJS WebApp

## Use Cases

### Default (GitHub)
Creates a GitHub repository and scaffolds the selected template. This is the traditional workflow for GitHub-based projects.

### GitLab
Creates a GitLab project and scaffolds the selected template. Supports both GitLab.com and self-hosted GitLab instances.

## Deployment

The stack is designed to be deployed through Cycloid's platform. The deployment process is automated through the pipeline configuration in the `pipeline/` directory.

### Pipeline Jobs

- `create-git-repo`: Creates a new GitHub or GitLab repository with initial configuration
- `scaffold-project`: Scaffolds the project using the selected template
- `destroy-git-repo`: Destroys the created repository

## Components

### Repository Management
- GitHub/GitLab repository creation
- Branch protection configuration
- Deploy key management
- SSH key generation and configuration

### Project Scaffolding
- Template-based project structure
- Development stack configuration
- Initial commit with template code
- Project-specific customization

## Directory Structure

- `terraform/`: Contains Terraform configuration files
  - `git.tf`: GitHub/GitLab repository configuration
  - `variables.tf`: Variable definitions
  - `provider.tf`: Provider configurations
  - `versions.tf`: Terraform and provider versions
  - `outputs.tf`: Output values
- `pipeline/`: Contains pipeline configuration for Cycloid
  - `pipeline.yml`: Main pipeline configuration
  - `variables.sample.yml`: Sample variables configuration
- `.cycloid.yml`: Cycloid project configuration
- `.forms.yml`: Forms configuration for Cycloid

## Security

- GitHub/GitLab credentials are managed securely through Cycloid's platform
- SSH keys are generated and stored securely
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
   - Adding or removing development stack templates
   - Customizing the form layout and organization
   - Implementing conditional form fields based on user selections

## Support

For support, please contact your Cycloid administrator or refer to the Cycloid documentation.

