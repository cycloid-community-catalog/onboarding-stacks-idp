resource "cycloid_organization_member" "tf_org_member_infrastructure" {
  for_each = toset(var.team_members_infrastructure)
  email = each.value
  role_canonical = "infrastructure"
  organization_canonical = var.cy_child_org_canonical
}

resource "cycloid_organization_member" "tf_org_member_application" {
  for_each = toset(var.team_members_application)
  email = each.value
  role_canonical = "application"
  organization_canonical = var.cy_child_org_canonical
}

resource "cycloid_organization_member" "tf_org_member_integration" {
  for_each = toset(var.team_members_integration)
  email = each.value
  role_canonical = "integration"
  organization_canonical = var.cy_child_org_canonical
}