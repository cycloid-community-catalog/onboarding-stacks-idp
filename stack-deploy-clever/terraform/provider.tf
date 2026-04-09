terraform {
  required_providers {
    clevercloud = {
      source  = "CleverCloud/clevercloud"
      # Peers refresh bug (destroy/plan): github.com/CleverCloud/terraform-provider-clevercloud/issues/337 — pipeline destroy sets TF_CLI_ARGS_destroy.
      version = "~> 1.11.0"
    }
    cycloid = {
      source  = "cycloidio/cycloid"
      version = "~> 0.3.1"
    }
  }
}

provider "clevercloud" {
  organisation = data.cycloid_credential.clever_cloud.body.raw["organization_id"]
  token        = data.cycloid_credential.clever_cloud.body.raw["cc_token"]
  secret       = data.cycloid_credential.clever_cloud.body.raw["cc_secret"]
}

provider "cycloid" {
  default_organization = var.cy_org
  api_key              = var.cy_api_key
  api_url              = var.cy_api_url
}