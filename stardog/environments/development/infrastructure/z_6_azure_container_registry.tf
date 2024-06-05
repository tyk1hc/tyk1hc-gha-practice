# Conainer Registry
resource "azurerm_container_registry" "container-registry-stardog" {
  name                = "${local.Project}${var.AzureResourceTypes["ContainerRegistry"]}stardog${local.Environment}${local.Location}"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
  location            = local.Location
  sku                 = "Standard"
}


