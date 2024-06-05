# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

data "azurerm_subscription" "current" {}

locals {
  module_name    = "storage_account"
  module_version = file("${path.module}/RELEASE")
  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    module_version      = local.module_version
    subscription        = data.azurerm_subscription.current.display_name
    terraform_workspace = terraform.workspace
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  access_tier                      = var.access_tier
  enable_https_traffic_only        = var.enable_https_traffic_only
  is_hns_enabled                   = var.is_hns_enabled
  min_tls_version                  = var.min_tls_version
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public

  network_rules {
    default_action             = var.network_rules_default_action
    bypass                     = var.network_rules_bypass
    ip_rules                   = var.network_rules_ip_rules
    virtual_network_subnet_ids = var.network_rules_virtual_network_subnet_ids
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain_name == null ? toset([]) : ["true"]

    content {
      name          = var.custom_domain_name
      use_subdomain = var.custom_domain_use_subdomain
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_versioning_enabled == true ? toset(["true"]) : toset([])
    content {
      versioning_enabled = var.blob_versioning_enabled
    }
  }

  identity {
    type = var.identity_type
  }

  tags = merge(var.tags, local.common_tags)

}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  count              = var.advanced_threat_protection == false ? 0 : 1
  target_resource_id = azurerm_storage_account.storage_account.id
  enabled            = var.advanced_threat_protection
}

resource "azurerm_monitor_diagnostic_setting" "storage_mondiags" {
  count                      = length(var.account_logging)
  name                       = "mondiag-${azurerm_storage_account.storage_account.name}-${var.service_logging[count.index]["service"]}"
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.account_logging[count.index]["logs"]
    content {
      category = log.key
      enabled  = log.value
      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.account_logging[count.index]["metrics"]
    content {
      category = metric.key
      enabled  = metric.value
      retention_policy {
        enabled = true
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_services_mondiags" {
  count                      = length(var.service_logging)
  name                       = "mondiag-${azurerm_storage_account.storage_account.name}-${var.service_logging[count.index]["service"]}"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/${var.service_logging[count.index]["service"]}Services/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.service_logging[count.index]["logs"]
    content {
      category = log.key
      enabled  = log.value
      retention_policy {
        enabled = true
              }
    }
  }

  dynamic "metric" {
    for_each = var.service_logging[count.index]["metrics"]
    content {
      category = metric.key
      enabled  = metric.value
      retention_policy {
        enabled = true
      }
    }
  }
  lifecycle {
    ignore_changes = [ log,metric ]
  }
}
