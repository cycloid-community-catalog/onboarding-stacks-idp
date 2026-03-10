provider "cycloid" {
  default_organization = var.cy_org
  api_key                = var.cy_api_key
  api_url                = var.cy_api_url
}

provider "github" {
  owner = var.github_organization
  token = var.github_pat
}
