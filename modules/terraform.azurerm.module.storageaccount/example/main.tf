# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt
provider "azurerm" {
  features {}
}

variable "name" {
  description = "The name of the resource group for the storage account"
  default     = "deletemesoon001"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-example-storageaccount-rg"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "la" {
  location            = azurerm_resource_group.rg.location
  name                = "deletemesoon-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

module "storage_account" {
  source                     = "../"
  name                       = var.name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = "westeurope"
# account_tier               = "Premium"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id
  service_logging = [
    { service = "blob", logs = { StorageRead = false, StorageWrite = true, storageDelete = true }, metrics = { Transaction = false } },
    { service = "table", logs = { StorageRead = false, StorageWrite = false, storageDelete = true }, metrics = { Transaction = true } }
  ]
  blob_versioning_enabled = true
  account_logging =[ ]#{ service = "account", logs = {}, metrics = { Transaction = true } }
  tags = {
    tag1  = "value2"
    scope = "automaticTestForTerraformAtBosch"
  }
}

