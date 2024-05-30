resource "azurerm_resource_group" "maintest" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = var.resource_environment_tags["development"]


  lifecycle {
    prevent_destroy = true
  }
}

