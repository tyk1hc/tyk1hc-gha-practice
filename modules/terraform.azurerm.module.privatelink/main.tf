resource "azurerm_private_link_service" "pvs" {
  name                = var.azurerm_private_link_service_name
  resource_group_name = var.resource_group_name
  location            = var.location

  auto_approval_subscription_ids              = ["00000000-0000-0000-0000-000000000000"]
  visibility_subscription_ids                 = ["00000000-0000-0000-0000-000000000000"]
  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids

  nat_ip_configuration {
    name                       = var.primary_nat_ip_name
    private_ip_address         = var.private_ip_address
    private_ip_address_version = "IPv4"
    subnet_id                  = var.aks_subnet_id
    primary                    = true
  }
}