module "argocd" {
  #####################################
  # Do not modify the following lines #
  source = "./module-argocd"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. argocd_version:  "7.8.3"
  #+ The version of ArgoCD to deploy
  argocd_version =  "7.8.3"

  #. argocd_git_url:  ""
  #+ The git URL for ArgoCD
  argocd_git_url =  github_repository.argocd.ssh_clone_url

  #. argocd_git_key:  ""
  #+ The SSH private key to access the ArgoCD git repo
  argocd_git_key =  tls_private_key.github_generated_key.private_key_openssh
}