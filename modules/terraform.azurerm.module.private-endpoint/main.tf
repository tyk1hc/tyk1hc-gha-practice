data "azurerm_subscription" "current" {
}

locals {
  module_name = "azure-private-endpoint"
  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    subscription        = data.azurerm_subscription.current.display_name
  }
}

##########################################################################################################
#Private end point creation
##########################################################################################################

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                              = var.private_service_connection_name
    subresource_names                 = var.subresource_names
    private_connection_resource_id    = var.private_connection_resource_id
    is_manual_connection              = false
    #request_message                  = var.approval_message
  }
  tags = merge(var.tags, local.common_tags)


private_dns_zone_group {
   # for_each = var.private_dns_zone_group[*]

   # content {
      name                 = var.private_dns_name
      private_dns_zone_ids = var.private_dns_zone_ids
   # }
  }

}
###########################################################################

// data "azurerm_private_endpoint_connection" "ple_connection" {
//    name       = azurerm_private_endpoint.private_endpoint.name
//    resource_group_name = data.azurerm_resource_group.resource_group.name
//  }



// # Create a local variable to the private IP address
// locals {
//    kube_ple_ip = data.azurerm_private_endpoint_connection.ple_connection.private_service_connection.0.private_ip_address
// }