terraform {
  required_version = ">= 1.0"
  
  required_providers {
    helm = {
      version = ">= 2.17.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.0"
    }
    cycloid = {
      source = "cycloidio/cycloid"
      version = ">= 0.0.20"
    }
  }
}