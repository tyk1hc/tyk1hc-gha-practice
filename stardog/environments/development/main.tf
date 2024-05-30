resource "azurerm_resource_group" "maintest" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags = {
    Environment = var.resource_environment_tags["development"]
  }


  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "maintestremove" {
  name     = "${var.resource_group_name}-remove"
  location = var.resource_group_location
  tags = {
    Environment = var.resource_environment_tags["development"]
  }
}