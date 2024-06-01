data "azurerm_subscription" "current" {
}

locals {
  module_name = "azure-private-dns"
  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    subscription        = data.azurerm_subscription.current.display_name
  }
}


##########################################################################################################
#Private DNS creation
##########################################################################################################

resource "azurerm_private_dns_zone" "privatelink_dns" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link_dns" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_dns.name
  virtual_network_id    = var.vnet_id

  depends_on = [
    azurerm_private_dns_zone.privatelink_dns
  ]
}