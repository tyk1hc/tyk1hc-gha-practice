resource "azurerm_dashboard_grafana" "example" {
  name                              = var.grafana_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  azure_monitor_workspace_integrations {
    resource_id = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.resource_group_name}/providers/microsoft.monitor/accounts/${var.PrometheusName}"
  }

  identity {
    type = "SystemAssigned"
  }
}


