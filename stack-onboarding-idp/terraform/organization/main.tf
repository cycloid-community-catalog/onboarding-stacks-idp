#
# Cycloid Organization
#
# resource "cycloid_organization" "child_org" {
#   name                   = var.cy_child_org
#   organization_canonical = var.cy_org

#   lifecycle {
#     ignore_changes = [organization_canonical]
#   }
# }