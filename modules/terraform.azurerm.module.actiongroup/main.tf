resource "azurerm_monitor_action_group" "example" {
  name                = var.actiongroup_name
  resource_group_name = var.action_group_resourcegroup
  short_name          = var.short_name
   email_receiver {
    name          = var.email_receiver_one
    email_address = var.email_address_one
  }
  lifecycle {
    ignore_changes = [ email_receiver ]
  }
  }