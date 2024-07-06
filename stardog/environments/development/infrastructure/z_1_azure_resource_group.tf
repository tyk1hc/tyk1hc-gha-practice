resource "azurerm_resource_group" "resource-group-virtual-network" {
  name     = local.ResourceGroup_Default_Name
  location = "southeastasia"
  tags = {
    Environment = local.Environment
  }
}