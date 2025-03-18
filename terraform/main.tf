# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0" # Usa la versión más reciente de la 3.x
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id # Variable
  tenant_id       = var.tenant_id       # Variable
}

resource "azurerm_resource_group" "rg" {
  name     = "DVR"
  location = "West Europe"
  tags = {
    environment = "casopractico2"
  }
}
