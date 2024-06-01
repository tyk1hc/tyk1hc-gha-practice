variable "resource_group" {
}
variable "logworkspace_resource_group" {
}
variable "nsg_name" {
}
variable "azurerm_network_watcher_flow_log_name" {
}
variable "connections" {
  default = []
}

variable "source_ip_addresses" {
  default = []
}
variable "outbound_ports" {
  default = []
}
variable "logging" {
  default = [
    { name = "NetworkSecurityGroupEvent", enabled = true },
    { name = "NetworkSecurityGroupRuleCounter", enabled = true },
  ]
}
variable "log_analytics_workspace_id" {}
variable "retention_days" {
  default= 90
}
variable "metrics_enabled" {
  default = false
}
variable "enable_logging" {
  default = true
}
variable "tags" {
  type        = map(string)
  description = "The tags to associate with this resource group."
  default     = {
    creator_source = "module"
  }
}

variable "enable_nsg_flow_logging" {
  /*default = {
    enabled = false
    network_watcher_name = "NetworkWatcher_westeurope"
    network_watcher_rg = "NetworkWatcherRG"
    interval_mins      = 60
    storage_account_name = "placeholder"
    storage_account_rg = "placeholder"

  }*/
  default = {}
}