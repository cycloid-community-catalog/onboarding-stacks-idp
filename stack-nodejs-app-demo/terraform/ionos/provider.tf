provider "ionoscloud" {
  token = var.ionos_cred.token
}

provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}