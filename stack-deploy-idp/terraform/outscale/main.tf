module "compute" {
  #####################################
  # Do not modify the following lines #
  source = "./module-compute"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. outscale_region: ""
  #+ The Outscale region where to deploy the infrastructure
  outscale_region = ""

  #. outscale_cpu_gen: "5"
  #+ The Outscale CPU Generation to deploy
  outscale_cpu_gen = "5"

  #. outscale_cpu: "1"
  #+ The number of CPU to deploy
  outscale_cpu = "1"

  #. outscale_mem: "1024"
  #+ The amount of memory to deploy
  outscale_mem = "1024"

  #. outscale_net: ""
  #+ The network where to deploy the infrastructure.
  outscale_net = ""

  #. outscale_private_network: ""
  #+ Whether to connect to an Outscale private network.
  outscale_private_network = ""
}