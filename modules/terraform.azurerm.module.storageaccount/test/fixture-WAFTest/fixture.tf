# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

provider "azurerm" {
  features {}
}

variable "name" {}
variable "location" {}
variable "network_rules_default_action" {}
variable "network_rules_ip_rules" {}
variable "network_rules_bypass" {}

locals {
  tags = {
    module_name = "terraform_azurerm.module.storageaccount"
    scope       = "StorageAccountWithFirewallTest"
    base_name   = var.name
  }
}

resource "azurerm_resource_group" "sa" {
  name     = "${var.name}-example-storageaccount-rg"
  location = var.location
  tags     = local.tags
}
resource "azurerm_log_analytics_workspace" "la" {
  location            = azurerm_resource_group.sa.location
  name                = "deletemesoon-${var.name}"
  resource_group_name = azurerm_resource_group.sa.name
  sku                 = "PerGB2018"
}
module "storage_account" {
  source                       = "../.."
  name                         = var.name
  resource_group_name          = azurerm_resource_group.sa.name
  location                     = var.location
  network_rules_default_action = "Deny"
  network_rules_ip_rules       = ["213.61.69.130"]
  network_rules_bypass         = ["AzureServices"]
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.la.id
}

output "id" {
  value = module.storage_account.id
}

output "module_name" {
  value = module.storage_account.name
}

output "rg_name" {
  value = module.storage_account.resource_group_name
}