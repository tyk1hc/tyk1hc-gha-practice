data "azurerm_subscription" "current" {}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  features {}
}

locals {
  nsg_rules = [
    { name                = "worker-to-worker",
      source_address      = "VirtualNetwork",
      source_port         = "8557",
      protocol            = "Tcp",
      destination_address = "VirtualNetwork",
      access              = "allow"
      priority = 100
    },
    { name                = "worker-to-worker-outbound",
      source_address      = "VirtualNetwork",
      destination_address = "VirtualNetwork",
      direction           = "outbound"
      priority = 100

    },
    {
      source_address      = "163.20.45.0/24",
      destination_address = "10.20.45.0/24",
      priority = 101
    },
    {
      priority = 102
    }
  ]
}
resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "deletemesoonplease"
}
resource "azurerm_log_analytics_workspace" "lana" {
  location            = azurerm_resource_group.rg.location
  name                = "log-analy-delmesoon"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}
/*
resource "azurerm_storage_account" "test" {
  name                     = "ststestfornsglf"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
}*/

module "nsg" {
#  depends_on                 = [azurerm_storage_account.test]
  source                     = "../."
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lana.id
  nsg_name                   = "somerandomname"
  resource_group             = azurerm_resource_group.rg
  connections                = local.nsg_rules
  /* enable_nsg_flow_logging = {
    network_watcher_name = "NetworkWatcher_${azurerm_resource_group.rg.location}",
    storage_account_name = azurerm_storage_account.test.name
    storage_account_rg = azurerm_storage_account.test.resource_group_name
    #optional, defaults to true : traffic_analytics_enabled = true
    #optional, defaults to 60 : interval_mins = 60
    #optional, defaults to 90 : retention_days = 90
  }
  */
}