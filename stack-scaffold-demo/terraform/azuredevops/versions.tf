terraform {
  required_version = ">= 1.5"
  
  required_providers {
    cycloid = {
      source = "cycloidio/cycloid"
      version = ">= 0.0.20"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
  }
}