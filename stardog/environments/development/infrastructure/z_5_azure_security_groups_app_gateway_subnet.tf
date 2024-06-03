resource "azurerm_network_security_group" "nsg-app-gateway-subnet" {
  name                = "${local.Project}-${var.AzureResourceTypes["NetworkSecurityGroup"]}-appGateway-subnet-${local.Environment}-${local.Location}"
  location            = local.Location
  resource_group_name = local.ResourceGroup_Default_Name
}

resource "azurerm_network_security_rule" "nsg-rule-gatewaymanager" {
  name                        = "gatewaymanager-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = local.ResourceGroup_Default_Name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_subnet_network_security_group_association" "gatewaymanager-association" {
  subnet_id                 = module.azure_virtual_network.subnets_map[local.Subnet_AppGateway]
  network_security_group_id = azurerm_network_security_group.nsg-app-gateway-subnet.id
}