# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

provider "azurerm" {
  features {}
}

variable "rg_name" {
  description = "The name of the resource group for the virtual network"
  default     = "vnettest-rg"
}

variable "vnet_name" {
  description = "The name of the key vault"
  default     = "vnet-example"
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = "westeurope"
}
resource "azurerm_log_analytics_workspace" "la" {
  location            = "westeurope"
  name                = "loganalytics-example-ka3jsah"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}
module "vnet" {
  source              = "../"
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  mondiag_enabled     = false
  address_space       = ["10.0.0.0/12"]
  tags = {
    tag1 = "example"
  }
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id
  subnets = {
    snet-datalake-subnet   = { subnet_name = "snet-datalake-subnet", subnet_cidr = ["10.0.2.0/24"],
      service_endpoint = ["Microsoft.Storage"], delegation_name = "", delegation_service = "", delegation_actions = []  , enforce_private_endpoint = true},
    snet-databricks-pubnet = { subnet_name = "snet-databricks-pubnet", subnet_cidr = ["10.0.4.0/24"],
      service_endpoint = ["Microsoft.Storage"], delegation_name = "AzureDatabrickDelegation", delegation_service = "Microsoft.Databricks/workspaces"}
  }
}