terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    github = {
      source = "integrations/github"
    }
    cycloid = {
      source = "cycloidio/cycloid"
    }
  }
}