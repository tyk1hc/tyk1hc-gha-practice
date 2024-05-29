resource "azurerm_resource_group" "maintest" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

