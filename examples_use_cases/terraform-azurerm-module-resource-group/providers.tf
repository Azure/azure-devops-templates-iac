terraform {
  required_version = ">= 1.2.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.41.0"
    }
  }
}

provider "azurerm" {
  features {}
}
