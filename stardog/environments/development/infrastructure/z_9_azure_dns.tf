module "private_dns_aks_customdns_vnet" {
  source                                     = "../../../../modules/terraform.azurerm.module.private-dns"
  dns_zone_name                              = "${local.Project}-${var.AzureResourceTypes["PrivateDomainNameServer"]}-aks-${local.Environment}"
  resource_group_name                        = azurerm_resource_group.resource-group-virtual-network.name
  location                                   = local.Location
  private_dns_zone_virtual_network_link_name = "${local.Project}-${var.AzureResourceTypes["PrivateLinkDomainNameServer"]}-aks-${local.Environment}"
  vnet_id                                    = module.azure_virtual_network.id
  tags                                       = { Environment = "Dev" }
}