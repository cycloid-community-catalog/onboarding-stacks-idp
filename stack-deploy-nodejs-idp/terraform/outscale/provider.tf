provider "outscale" {
  access_key_id   = var.outscale_cred.access_key
  secret_key_id   = var.outscale_cred.secret_key
  region          = var.outscale_region
}

provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}