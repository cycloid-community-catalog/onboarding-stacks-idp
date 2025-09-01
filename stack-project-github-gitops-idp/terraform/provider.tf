provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}

provider "github" {
  owner = var.github_organization
  token = var.github_pat.password
}
