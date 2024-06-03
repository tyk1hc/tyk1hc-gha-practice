resource "azurerm_network_security_group" "nsg-common-subnet" {
  name                = "${local.Project}-${var.AzureResourceTypes["NetworkSecurityGroup"]}-Common-Subnet-${local.Environment}-${local.Location}"
  location            = local.Location
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
}

resource "azurerm_network_security_rule" "nsg-rule-BTIAAcess" {
  name                        = "BTIAAccess"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes       = ["103.4.127.176","194.39.218.13"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-common-subnet.name
}

resource "azurerm_subnet_network_security_group_association" "common-subnet-association" {
  subnet_id                 = module.azure_virtual_network.subnets_map[local.Subnet_Common]
  network_security_group_id = azurerm_network_security_group.nsg-common-subnet.id
}