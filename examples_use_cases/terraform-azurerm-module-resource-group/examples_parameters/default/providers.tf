terraform {
  required_version = ">= 1.2.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.1"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "random" {
}
