provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.azuredevops_org}"
  personal_access_token = var.azuredevops_pat
}
