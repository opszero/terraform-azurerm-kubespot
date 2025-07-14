terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37.1"
    }

  }
  required_version = ">= 0.13"
}