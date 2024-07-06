#module "diagstore" {
#  source                       = "../../../../modules/terraform.azurerm.module.storageaccount"
#  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}diagstore${local.Environment}"
#  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
#  location                     = local.Location
#  tags                         = { Environment = "Dev" }
#  account_tier                 = "Standard"
#  account_kind                 = "StorageV2"
#  account_replication_type     = "LRS"
#  network_rules_default_action = "Deny"
#  network_rules_bypass         = ["AzureServices", "Logging"]
#  min_tls_version              = "TLS1_2"
#  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
#  advanced_threat_protection   = "false"
#}

resource "azurerm_storage_account" "st-diagstore" {
  name                = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}diagstore${local.Environment}"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name

  location                 = local.Location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    bypass                     = ["AzureServices", "Logging"]
    virtual_network_subnet_ids = []
  }

  tags = {
    Environment = "Dev"
  }
}


#module "flow_log_storage" {
#  source                       = "../../../../modules/terraform.azurerm.module.storageaccount"
#  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}flowlogstorage${local.Environment}"
#  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
#  location                     = local.Location
#  min_tls_version              = "TLS1_2"
#  tags                         = { Environment = "Dev" }
#  network_rules_default_action = "Deny"
#  network_rules_bypass         = ["AzureServices", "Logging"]
#  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
#  advanced_threat_protection   = "false"
#}

resource "azurerm_storage_account" "st-flowlogstorage" {
  name                = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}flowlogstorage${local.Environment}"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name

  location                 = local.Location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    bypass                     = ["AzureServices", "Logging"]
    virtual_network_subnet_ids = []
  }

  tags = {
    Environment = "Dev"
  }
}

#module "k8spvc" {
#  source                       = "../../../../modules/terraform.azurerm.module.storageaccount"
#  name                         = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}k8spvc${local.Environment}"
#  resource_group_name          = azurerm_resource_group.resource-group-virtual-network.name
#  location                     = local.Location
#  tags                         = { Environment = "Dev" }
#  account_tier                 = "Standard"
#  account_kind                 = "StorageV2"
#  account_replication_type     = "LRS"
#  network_rules_default_action = "Deny"
#  network_rules_bypass         = ["AzureServices", "Logging"]
#  min_tls_version              = "TLS1_2"
#  log_analytics_workspace_id   = azurerm_log_analytics_workspace.Log_Analytics_Workspace_Default.id
#  advanced_threat_protection   = "false"
#}


resource "azurerm_storage_account" "st-k8spvc" {
  name                = "${local.Project}${var.AzureResourceTypes["StorageAccount"]}k8spvc${local.Environment}"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name

  location                 = local.Location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = []
    bypass                     = ["AzureServices", "Logging"]
    virtual_network_subnet_ids = []
  }

  tags = {
    Environment = "Dev"
  }
}
