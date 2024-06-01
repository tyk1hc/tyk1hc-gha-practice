locals {
  module_name = "azure-firewall"
  common_tags = {
    creator             = "terraform"
    module_name         = local.module_name
    subscription        = data.azurerm_subscription.current.display_name
    terraform_workspace = terraform.workspace
  }
}