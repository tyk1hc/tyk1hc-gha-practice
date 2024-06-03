resource "azurerm_network_security_group" "nsg-common-subnet" {
  name                = "${local.Project}-${var.AzureResourceTypes["NetworkSecurityGroup"]}-Common-Subnet-${local.Environment}-${local.Location}"
  location            = local.Location
  resource_group_name = local.ResourceGroup_Default_Name
}

resource "azurerm_network_security_rule" "nsg-rule-BTIAAcess" {
  name                        = "BTIAAccess"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = ["103.4.127.176","194.39.218.13"]
  destination_address_prefix  = "*"
  resource_group_name         = local.ResourceGroup_Default_Name
  network_security_group_name = azurerm_network_security_group.nsg-common-subnet.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = module.vnet.subnets_map[local.Subnet_Common]
  network_security_group_id = azurerm_network_security_group.nsg-common-subnet.id
}