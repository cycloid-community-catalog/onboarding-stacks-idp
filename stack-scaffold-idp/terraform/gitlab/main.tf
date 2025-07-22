module "cycloid-cred-git" {
  #####################################
  # Do not modify the following lines #
  source    = "./module-cycloid-cred-git"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. git_ssh_key: ''
  #+ Git repository SSH private key for stacks and config
  git_ssh_key = tls_private_key.gitlab_generated_key.private_key_openssh

  depends_on = [ gitlab_project.scaffold ]
}