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
  organisation = var.clevercloud_organisation
  token        = var.clevercloud_token
  secret       = var.clevercloud_secret
}

provider "cycloid" {
  default_organization = var.cy_org
  api_key              = var.cy_api_key
  api_url              = var.cy_api_url
}