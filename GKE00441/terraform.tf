terraform {
  required_version = ">= 1.0.2, <2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 3.5"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "> 2.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "> 3.5"
    }
  }
}
