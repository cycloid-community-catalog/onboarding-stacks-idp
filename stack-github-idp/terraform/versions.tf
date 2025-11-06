terraform {
  required_version = ">= 1.5"
  
  required_providers {
    cycloid = {
      source = "cycloidio/cycloid"
      version = ">= 0.0.23"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.0"
    }
  }
}