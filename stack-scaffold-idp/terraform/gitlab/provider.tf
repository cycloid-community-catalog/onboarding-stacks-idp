provider "cycloid" {
  organization_canonical = var.cy_org
  jwt                    = var.cy_api_key
  url                    = var.cy_api_url
}

provider "gitlab" {
  base_url = var.gitlab_url
  token    = var.gitlab_pat.password
}