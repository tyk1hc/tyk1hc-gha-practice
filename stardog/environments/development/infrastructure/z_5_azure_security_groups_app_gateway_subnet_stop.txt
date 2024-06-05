resource "azurerm_network_security_group" "nsg-app-gateway-subnet" {
  name                = "${local.Project}-${var.AzureResourceTypes["NetworkSecurityGroup"]}-appGateway-subnet-${local.Environment}-${local.Location}"
  location            = local.Location
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
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
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_network_security_rule" "nsg-rule-appgateway-https" {
  name                        = "appgateway-https-inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes       = ["139.15.0.0/16", "194.39.218.0/23", "193.141.57.0/24", "193.108.217.0/24", "149.226.0.0/16", "209.221.240.0/21", "209.221.248.0/22", "209.221.252.0/23", "216.213.48.0/22", "216.213.56.0/21", "177.11.252.0/24", "170.245.134.0/23", "119.40.64.0/20", "58.210.106.224/27", "103.155.91.64/28", "103.4.124.0/22", "45.112.36.0/22", "103.205.152.0/22"]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_network_security_rule" "nsg-rule-appgateway-http" {
  name                        = "appgateway-http-inbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes       = ["139.15.0.0/16", "194.39.218.0/23", "193.141.57.0/24", "193.108.217.0/24", "149.226.0.0/16", "209.221.240.0/21", "209.221.248.0/22", "209.221.252.0/23", "216.213.48.0/22", "216.213.56.0/21", "177.11.252.0/24", "170.245.134.0/23", "119.40.64.0/20", "58.210.106.224/27", "103.155.91.64/28", "103.4.124.0/22", "45.112.36.0/22", "103.205.152.0/22"]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_network_security_rule" "nsg-rule-appgateway-specialSetups" {
  name                        = "appgateway-special-setups-inbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes       = ["194.39.218.13", "194.39.218.32", "139.15.142.49", "139.15.99.64/27", "209.221.240.158", "216.213.49.16/28", "195.11.167.73", "103.4.127.176", "149.226.194.32/28", "119.40.78.16", "103.205.153.241", "103.205.154.80/28"]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_network_security_rule" "nsg-rule-appgateway-stardog-monitoring" {
  name                        = "appgateway-stardog-monitoring-inbound"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes       =["3.71.170.0/24","3.71.103.96/27","3.75.4.128/25"]
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.resource-group-virtual-network.name
  network_security_group_name = azurerm_network_security_group.nsg-app-gateway-subnet.name
}

resource "azurerm_subnet_network_security_group_association" "gatewaymanager-association" {
  subnet_id                 = module.azure_virtual_network.subnets_map[local.Subnet_AppGateway]
  network_security_group_id = azurerm_network_security_group.nsg-app-gateway-subnet.id
}