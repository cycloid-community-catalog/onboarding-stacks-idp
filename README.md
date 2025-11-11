# Onboarding Stacks for Cycloid IDP

Cycloid's onboarding stacks accelerate the setup of a developer platform by bundling opinionated Terraform modules, Concourse pipelines, and templated manifests that teams can reuse with minimal customization.

## What's Inside

| Stack | Directory | Primary Use |
|-------|-----------|-------------|
| GitHub GitOps Project | `stack-github-idp/` | Scaffold GitHub repositories, set up CI/CD, and manage PR-based test environments |
| Deploy Manifests | `stack-deploy-idp/` | Render Kubernetes manifests and push them to a GitOps repository watched by ArgoCD |
| Kubernetes + ArgoCD | `stack-k8s-argocd/` | Provision a single-node Kubernetes cluster on AWS with ArgoCD and supporting services |
| PostgreSQL Database | `stack-postgresql/` | Create managed PostgreSQL instances across AWS, Azure, or GCP |

## Stack Layout Basics

- `pipeline/`: Concourse resource and job definitions plus sample variable files.
- `terraform/`: Infrastructure modules, providers, and outputs for stacks that provision resources.
- `templating/`: YAML or JSON templates rendered by the pipelines before being committed to GitOps repositories.
- `.forms.yml`: Cycloid form definitions surfacing stack inputs in the UI when present.
- `README.md`: Stack-specific guidance, architecture notes, and prerequisites.

## Recommended Workflow

- Bootstrap platform infrastructure with `stack-k8s-argocd/` when a managed cluster and ArgoCD are required.
- Scaffold application repositories and PR environments with `stack-github-idp/`.
- Provision data services using `stack-postgresql/`, selecting the appropriate cloud provider use case.
- Create Pull Requests from the new application repositories. Test environments are created automatically using ArgoCD manifests.
- Deliver containerized workloads via `stack-deploy-idp/`, which renders manifests and commits them to the manifests repo.
- Iterate locally by adjusting templates or Terraform modules, committing changes, and re-running specific pipeline jobs.

## Useful References

- `stack-github-idp/README.md`
- `stack-deploy-idp/README.md`
- `stack-k8s-argocd/README.md`
- `stack-postgresql/README.md`
- Cycloid product documentation: https://docs.cycloid.io/