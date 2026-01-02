terraform {
  required_version = ">= 1.0"
  
  required_providers {
    outscale = {
      source = "outscale/outscale"
      version = ">= 1.0"
    }

    cycloid = {
      source = "cycloidio/cycloid"
      version = ">= 0.0.20"
    }
  }
}