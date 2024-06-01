output "resourcegroup_default_name" {
  value = azurerm_resource_group.resource-group-virtual-network.name
}

output "loganalyticworkspace_default_id" {
  value = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
}