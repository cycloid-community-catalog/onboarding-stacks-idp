data "azurerm_resource_group" "selected" {
  count = var.res_selector == "create" ? 0 : 1

  name = var.res_selector == "inventory" ? var.resource_group_name_inventory : var.resource_group_name_manual
}

resource "azurerm_resource_group" "compute" {
  count = var.res_selector == "create" ? 1 : 0

  name     = "${var.cy_org}-${var.cy_project}-${var.cy_env}-${var.cy_component}"
  location = var.azure_location
}