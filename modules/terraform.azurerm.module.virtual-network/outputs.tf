# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

output "id" {
  value = azurerm_virtual_network.vnet.id
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "tags" {
  value = azurerm_virtual_network.vnet.tags
}

output "address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "subnets_map" {
  value = { for o in azurerm_subnet.subnets : o.name => o.id }
}