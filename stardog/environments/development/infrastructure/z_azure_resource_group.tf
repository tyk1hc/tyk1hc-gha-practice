resource "azurerm_resource_group" "resource-group-virtual-network" {
  name     = "${local.ResourceGroup_VirtualNetwork}"
  location = "East Asia"
  tags = {
    Environment = "${local.Environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}