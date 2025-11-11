terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.6.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.70.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}

provider "tfe" {
  organization = var.hcp_terraform_organization
}
