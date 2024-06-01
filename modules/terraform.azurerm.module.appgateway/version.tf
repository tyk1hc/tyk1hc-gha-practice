# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#      # version = ">= 2.93.0"
#     }
#     random = {
#       source = "hashicorp/random"
#     }
#   }
#   required_version = ">= 0.13"

# }

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version=">=3.40.0, <4.0.0"
    }
  }
}

# provider "azurerm" {
#   features {}

# }