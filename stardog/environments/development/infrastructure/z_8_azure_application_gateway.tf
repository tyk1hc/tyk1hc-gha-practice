resource "azurerm_user_assigned_identity" "appgateway-identity" {
  location            = local.Location
  name                = "${local.Project}appgateway${local.Environment}one"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
}

resource "azurerm_public_ip" "appgateway-public-ip" {
  name                = "${local.Project}appgatewayip${local.Environment}one"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
  location            = local.Location
  allocation_method   = "Static"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_application_gateway" "aks-application-gateway" {
    name                = "${local.Project}-${var.AzureResourceTypes["ApplicationGateway"]}-aks-${local.Environment}"
    resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
    location            = local.Location

    tags                = { Environment = "Dev"}

    sku {
        name     = "WAF_v2"
        tier     = "WAF_v2"
        capacity = 1
    }

    gateway_ip_configuration {
        name      = "my-gateway-ip-configuration"
        subnet_id = module.azure_virtual_network.subnets_map[local.Subnet_AppGateway]
    }

    frontend_port {
        name = local.frontend_port_name
        port = 80
    }

    frontend_ip_configuration {
        name                 = local.frontend_ip_configuration_name
        public_ip_address_id = azurerm_public_ip.appgateway-public-ip.id
    }

    backend_address_pool {
        name = local.backend_address_pool_name
    }

    backend_http_settings {
        name                  = local.http_setting_name
        cookie_based_affinity = "Disabled"
        path                  = "/path1/"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 60
    }

    http_listener {
        name                           = local.listener_name
        frontend_ip_configuration_name = local.frontend_ip_configuration_name
        frontend_port_name             = local.frontend_port_name
        protocol                       = "Http"
    }

    request_routing_rule {
        name                       = local.request_routing_rule_name
        priority                   = 9
        rule_type                  = "Basic"
        http_listener_name         = local.listener_name
        backend_address_pool_name  = local.backend_address_pool_name
        backend_http_settings_name = local.http_setting_name
    }

    lifecycle {
        ignore_changes = [
            backend_address_pool,
            backend_http_settings,
            frontend_port,
            frontend_ip_configuration,
            http_listener,
            probe,
            redirect_configuration,
            request_routing_rule,
            ssl_certificate,
            waf_configuration,
            url_path_map,
            firewall_policy_id,
            force_firewall_policy_association,
            tags,
            ssl_policy
        ]
    }

}