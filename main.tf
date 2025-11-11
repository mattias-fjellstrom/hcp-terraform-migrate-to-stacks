terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }

  cloud {
    organization = "mattias-fjellstrom"

    workspaces {
      name = "source-workspace"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "rg-tf-migrate-${var.location}"
  location = var.location

  tags = {
    managed_by = "terraform"
    stacks     = "${var.stacks}"
  }
}
