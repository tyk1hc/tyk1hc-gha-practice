# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

data "azurerm_subscription" "current" {
}

locals {
  module_name    = "virtual_network"
  module_version = file("${path.module}/RELEASE")

  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    module_version      = local.module_version
    subscription        = data.azurerm_subscription.current.display_name
    terraform_workspace = terraform.workspace
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  location            = var.location
  tags                = merge(var.tags, local.common_tags)

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan == null ? toset([]) : [
    var.ddos_protection_plan]
    content {
      id     = var.ddos_protection_plan
      enable = true
    }
  }
}

resource "azurerm_subnet" "subnets" {
  for_each                                       = var.subnets
  name                                           = each.value["subnet_name"]
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = each.value["subnet_cidr"]
  service_endpoints                              = lookup(each.value,"service_endpoint",[])
  #enforce_private_link_endpoint_network_policies = lookup(each.value,"enforce_private_endpoint",false)
  #enforce_private_link_service_network_policies  = lookup(each.value,"enforce_private_link_service", false)

  dynamic "delegation" {
    for_each = lookup(each.value,"delegation_name","") == "" ? toset([]) : ["true"]
    content {
      name = lookup(each.value,"delegation_name","")
      service_delegation {
        name    = lookup(each.value,"delegation_service","")
        actions = lookup(each.value,"delegation_actions",[])
      }
    }
  }
  lifecycle {
    #ignore_changes = [ service_endpoints,enforce_private_link_endpoint_network_policies ]
    ignore_changes = [ service_endpoints ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "mondiag" {
  count                      = var.mondiag_enabled == false ? 0 : 1
  name                       = var.diag_name
  target_resource_id         = azurerm_virtual_network.vnet.id
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
  lifecycle {
    ignore_changes = [ metric ]
  }
}
