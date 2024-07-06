resource "azurerm_resource_group" "resource-group-virtual-network" {
  name     = local.ResourceGroup_Default_Name
  location = "Southeast Asia"
  tags = {
    Environment = local.Environment
  }
}