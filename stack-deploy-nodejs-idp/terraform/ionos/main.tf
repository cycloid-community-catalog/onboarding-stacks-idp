module "compute" {
  #####################################
  # Do not modify the following lines #
  source = "./module-compute"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. ionos_region: ""
  #+ The IONOS region where to deploy the infrastructure
  ionos_region = var.ionos_region

  #. ionos_cube: ""
  #+ The IONOS cube configuration to deploy
  ionos_cube = ""

  #. ionos_lan: ""
  #+ The network where to deploy the infrastructure.
  ionos_lan = ""

  #. ionos_private_network: ""
  #+ Whether to connect the instance to a IONOS private network.
  ionos_private_network = ""
}