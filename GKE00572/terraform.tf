terraform {
  required_version = ">= 1.0.2, <2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 3.5"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}
