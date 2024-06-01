locals {
  module_name    = "nsg-module"
  module_version = file("${path.module}/RELEASE")
  common_tags = {
    creator        = "terraform"
    module_name    = local.module_name
    module_version = local.module_version
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  dynamic "security_rule" {
    for_each = var.connections
    content {
      name                       = lookup(security_rule.value, "name", security_rule.key)
      priority                   = lookup(security_rule.value, "priority", 100 + security_rule.key)
      direction                  = title(lookup(security_rule.value, "direction", "inbound"))
      access                     = title(lookup(security_rule.value, "access", "Allow"))
      protocol                   = lookup(security_rule.value, "protocol", "*")
      source_port_range          = lookup(security_rule.value, "source_port", "*")
      destination_port_range     = lookup(security_rule.value, "destination_port", "*")
      source_address_prefix      = lookup(security_rule.value, "source_address", null)
      #source_address_prefixes    = var.source_ip_addresses
      source_address_prefixes    = lookup(security_rule.value, "source_ip_addresses", null)
      destination_address_prefix = lookup(security_rule.value, "destination_address", "VirtualNetwork")
    }
  }
  tags = merge(var.tags, local.common_tags)
}

resource "azurerm_monitor_diagnostic_setting" "mondiags" {
  count                      = var.enable_logging ? 1 : 0
  name                       = "mondiag-${azurerm_network_security_group.nsg.name}"
  target_resource_id         = azurerm_network_security_group.nsg.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.logging
    content {
      category = enabled_log.value.name
      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.metrics_enabled == false ? [] : [1]
    content {
      category = "AllMetrics"
      retention_policy {
        enabled = true
      }
    }
  }
}

data "azurerm_storage_account" "nsgflsa" {
  count               = lookup(var.enable_nsg_flow_logging, "network_watcher_name", "not found") != "not found" ? 1 : 0
  name                = var.enable_nsg_flow_logging["storage_account_name"]
  resource_group_name = lookup(var.enable_nsg_flow_logging, "storage_account_rg", "NetworkWatcherRG")
}

data "azurerm_log_analytics_workspace" "nsglogworkspace" {
  count               = lookup(var.enable_nsg_flow_logging, "network_watcher_name", "not found") != "not found" ? 1 : 0
  name                = split("/", var.log_analytics_workspace_id)[8]
  resource_group_name = var.logworkspace_resource_group.name
}

resource "azurerm_network_watcher_flow_log" "enfllog" {
  count                     = lookup(var.enable_nsg_flow_logging, "network_watcher_name", "not found") != "not found" ? 1 : 0
  name                      = var.azurerm_network_watcher_flow_log_name
  network_security_group_id = azurerm_network_security_group.nsg.id
  storage_account_id        = data.azurerm_storage_account.nsgflsa[0].id
  network_watcher_name      = var.enable_nsg_flow_logging["network_watcher_name"]
  resource_group_name       = lookup(var.enable_nsg_flow_logging, "network_watcher_rg", "NetworkWatcherRG")
  enabled                   = lookup(var.enable_nsg_flow_logging, "network_watcher_name", "not found") != "not found" ? true : false

  retention_policy {
    enabled = lookup(var.enable_nsg_flow_logging, "retention_policy", true)
    days    = lookup(var.enable_nsg_flow_logging, "retention_days", 90)
  }
  traffic_analytics {
    enabled               = lookup(var.enable_nsg_flow_logging, "traffic_analytics_enabled", true)
    workspace_id          = data.azurerm_log_analytics_workspace.nsglogworkspace[0].workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.nsglogworkspace[0].location
    workspace_resource_id = data.azurerm_log_analytics_workspace.nsglogworkspace[0].id
    interval_in_minutes   = lookup(var.enable_nsg_flow_logging, "interval_mins", 60)
  }
  lifecycle {
    ignore_changes = [ traffic_analytics,storage_account_id ]
  }
}
