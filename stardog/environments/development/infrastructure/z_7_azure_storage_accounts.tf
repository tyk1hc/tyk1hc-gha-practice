module "diagstore" {
  source                       = "../../../../modules/terraform-source-modules/terraform.azurerm.module.storageaccount"
  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}diagstore${local.Environment}${local.Location}"
  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
  location                     = local.Location
  tags                         = { Environment = "Dev" }
  account_tier                 = "Standard"
  account_kind                 = "StorageV2"
  account_replication_type     = "LRS"
  network_rules_default_action = "Deny"
  network_rules_bypass         = ["AzureServices", "Logging"]
  min_tls_version              = "TLS1_2"
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
  advanced_threat_protection   = "false"
}

module "flow_log_storage" {
  source                       = "../../../../modules/terraform-source-modules/terraform.azurerm.module.storageaccount"
  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}flowlogstorage${local.Environment}${local.Location}"
  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
  location                     = local.Location
  min_tls_version              = "TLS1_2"
  tags                         = { Environment = "Dev" }
  network_rules_default_action = "Deny"
  network_rules_bypass         = ["AzureServices", "Logging"]
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
  advanced_threat_protection   = "false"
}

module "k8spvc" {
  source                       = "../../../../modules/terraform-source-modules/terraform.azurerm.module.storageaccount"
  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}k8spvc${local.Environment}${local.Location}"
  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
  location                     = local.Location
  tags                         = { Environment = "Dev" }
  account_tier                 = "Standard"
  account_kind                 = "StorageV2"
  account_replication_type     = "LRS"
  network_rules_default_action = "Deny"
  network_rules_bypass         = ["AzureServices", "Logging"]
  min_tls_version              = "TLS1_2"
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
  advanced_threat_protection   = "false"
}