module "azure_virtual_network" {
  source                     = "../../../../modules/terraform.azurerm.module.virtual-network"
  resource_group_name        = local.ResourceGroup_Default_Name
  name                       = local.VirtualNetwork_Name
  location                   = local.Location
  mondiag_enabled            = false
  address_space              = ["${var.vnet_default_address_spaces}"]
  log_analytics_workspace_id = module.loganalytics_network_aks_ws.id
  diag_name                  = local.VirtualNetwork_Diag_Name
  subnets                    = local.VirtualNetwork_Subnets

  tags                       = {Environment = local.Environment}

  depends_on = [ azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default, azurerm_resource_group.resource-group-virtual-network ]
}