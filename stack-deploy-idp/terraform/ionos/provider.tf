provider "ionoscloud" {
  token = var.ionos_cred.token
}

provider "cycloid" {
  default_organization = var.cy_org
  api_key                = var.cy_api_key
  api_url                = var.cy_api_url
}