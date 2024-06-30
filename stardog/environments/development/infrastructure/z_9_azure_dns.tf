module "private_dns_aks_customdns_vnet" {
  source                                     = "../../../../modules/terraform.azurerm.module.private-dns"
  dns_zone_name                              = "privatelink.${local.Location}.azmk8s.io"
  resource_group_name                        = azurerm_resource_group.resource-group-virtual-network.name
  location                                   = local.Location
  private_dns_zone_virtual_network_link_name = "${local.Project}-${local.Environment}-private-dns-aks-vnet-link"
  vnet_id                                    = module.azure_virtual_network.id
  tags                                       = { Environment = "Dev" }
}
