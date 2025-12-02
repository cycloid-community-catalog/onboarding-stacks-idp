module "compute" {
  #####################################
  # Do not modify the following lines #
  source       = "./module-compute"
  cy_org       = var.cy_org
  cy_project   = var.cy_project
  cy_env       = var.cy_env
  cy_component = var.cy_component
  #####################################

  #. vm_instance_type: 'Standard_DS2_v2'
  #+ Instance type for the VM
  vm_instance_type = ""

  #. vm_disk_size: 30
  #+ Disk size for the VM (Go)
  vm_disk_size = 30

  #. vm_ports_in: [22, 80, 443, 3000, 8080]
  #+ Ingress TCP ports allowed from the internet
  vm_ports_in = [22, 80, 443, 3000, 8080]

  #. res_selector: ''
  #+ Whether to create a new VPC or select an existing one
  res_selector = ""

  #. azure_location: ""
  #+ Azure location
  azure_location = ""

  #. resource_group_name_inventory: ''
  #+ The name of the existing resource group where the resources will be deployed
  resource_group_name_inventory = ""

  #. resource_group_name_manual: ''
  #+ The name of the existing resource group where the resources will be deployed
  resource_group_name_manual = ""

  #. database_enabled: ''
  #+ Does you application needs a database?
  database_enabled = ""

  #. database_env_var_name: ''
  #+ Database Connection String Environment Var Name
  database_env_var_name = ""

  #. database_resource: ''
  #+ The AWS RDS instance that your application will connect to. Blank if there is no database to integrate.
  database_resource = ""
}