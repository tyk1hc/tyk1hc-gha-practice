resource "azurerm_resource_group" "maintest" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    Environment = var.resource_environment_tags["production"]
  }

  lifecycle {
    prevent_destroy = true
  }
}