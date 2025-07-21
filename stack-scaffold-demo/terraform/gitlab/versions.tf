terraform {
  required_version = ">= 1.5"
  
  required_providers {
    cycloid = {
      source = "cycloidio/cycloid"
      version = ">= 0.0.21"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 16.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
} 