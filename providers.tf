terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.2"
    }
  }
}
