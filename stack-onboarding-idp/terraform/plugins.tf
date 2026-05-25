#
# ArgoCD Plugin
#

resource "time_sleep" "wait_for_org_propagation" {
  create_duration = "10s"
}

resource "cycloid_plugin_registry" "local" {
  organization         = var.cy_child_org_canonical
  name                 = "local"
  url                  = "http://cycloid-plugin-registry:4000"
  wait_until_connected = true

  depends_on = [time_sleep.wait_for_org_propagation]
}

resource "cycloid_plugin_manager" "default" {
  organization         = var.cy_child_org_canonical
  name                 = "default-plugin-manager"
  url                  = "http://cycloid-plugin-manager:4001"
  wait_until_connected = true

  depends_on = [time_sleep.wait_for_org_propagation]
}