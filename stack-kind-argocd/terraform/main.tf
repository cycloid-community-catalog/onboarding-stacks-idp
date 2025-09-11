module "compute" {
  #####################################
  # Do not modify the following lines #
  source   = "./module-compute"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. aws_region: ''
  #+ AWS region where to deploy the resoureces
  aws_region = var.aws_region

  #. vm_instance_type: 't3.micro'
  #+ Instance type for the VM
  vm_instance_type = ""

  #. vm_disk_size: 20
  #+ Disk size for the VM (Go)
  vm_disk_size = ""

  #. res_selector: ''
  #+ Whether to create a new VPC or select an existing one
  res_selector = ""

  #. vpc_id_inventory: ''
  #+ VPC where to deploy the resources
  vpc_id_inventory = ""

  #. vpc_id_manual: ''
  #+ VPC where to deploy the resources
  vpc_id_manual = ""

  #. argocd_version: ''
  #+ ArgoCD version to deploy
  argocd_version = ""

  #. git_ssh_url: ''
  #+ SSH URL to access the Git repository
  git_ssh_url = github_repository.manifests.ssh_clone_url

  #. git_private_key: ''
  #+ Private key to access the Git repository
  git_private_key = tls_private_key.github_generated_key.private_key_openssh
}
