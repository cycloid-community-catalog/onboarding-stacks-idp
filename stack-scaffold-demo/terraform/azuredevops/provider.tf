provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.azuredevops_org}"
  client_id       = var.azure_cred["client_id"]
  client_secret   = var.azure_cred["client_secret"]
  subscription_id = var.azure_cred["subscription_id"]
  tenant_id       = var.azure_cred["tenant_id"]
}
