provider "outscale" {
  access_key_id   = var.outscale_cred.access_key
  secret_key_id   = var.outscale_cred.secret_key
  region          = var.outscale_region
}

provider "cycloid" {
  default_organization = var.cy_org
  api_key                = var.cy_api_key
  api_url                = var.cy_api_url
}