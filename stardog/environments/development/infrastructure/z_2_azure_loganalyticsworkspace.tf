resource "azurerm_log_analytics_workspace" "Log_Analytics_Workspace_Default" {
  name                = local.LogAnalyticWorkSpace_Name
  location            = local.Location
  resource_group_name = local.ResourceGroup_Default_Name
  sku                 = "PerGB2018"
 retention_in_days   = 30

  depends_on = [ azurerm_resource_group.resource-group-virtual-network ]
}