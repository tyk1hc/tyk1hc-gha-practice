##########################################################################################################
#Resource Group
##########################################################################################################

// data "azurerm_resource_group" "resource_group" {
//   name = var.resource_group_name
// }



# Application Gateway 

# locals {
#   # public_ip_name = "${local.naming_convention}-apppgw-ip"
#   # # appgw_name = "${var.prefix}-appgw-default-jjb-${var.location}"
#   # appgw_name                      = "${local.naming_convention}-appgw-aks-01"
#   naming_convention               = "${var.projectname}-${var.env}"
#   appgw_ip_config_name            = "${local.naming_convention}-appgw-default-ip"
#   appgw_frontend_port_name        = "${local.naming_convention}-appgw-frontend-port"
#   appgw_frontend_ip_config_name   = "${local.naming_convention}-appgw-frontend-ip"
#   appgw_backend_address_pool_name = "${local.naming_convention}-appgw-backend-address-pool"
#   appgw_http_setting_name         = "${local.naming_convention}-appgw-http-setting"
#   appgw_https_listener_name       = "${local.naming_convention}-appgw-https-listener"
#   appgw_request_routing_name      = "${local.naming_convention}-appgw-request-routing"
#   appgw_https_port_name           = "${local.naming_convention}-appgw-https-port"
  
  # appgw_cert_name                 = var.cert_name
# }


# resource "azurerm_public_ip" "ip" {
#   name                = "my-pub-ip"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   allocation_method   = var.allocation_method
#   # domain_name_label   = var.domain_name_label
#   sku                 = "Standard"
#   tags                = var.tags
# }

resource "azurerm_application_gateway" "appgw" {
  # count               = var.resource_count
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = true
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"  #AppGwSslPolicy20170401S
    #enable_http2 = true
    min_protocol_version = "TLSv1_2"
  }
  identity {
    type = var.identity_type
    identity_ids = var.identity_ids
  }

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = 1
  }

  gateway_ip_configuration {
    # name      = local.appgw_ip_config_name
    name = var.appgw_ip_config_name
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = var.appgw_frontend_ip_config_name
    public_ip_address_id = var.public_ip_address_id
  }
  
  frontend_port {
    name = var.appgw_https_port_name
    # port = 443
    port = 80
  }


  http_listener {
    name                           = var.appgw_https_listener_name
    frontend_ip_configuration_name = var.appgw_frontend_ip_config_name
    frontend_port_name             = var.appgw_https_port_name
    protocol                       = "Http"
    #protocol                       = "Https"
    require_sni = false
    # ssl_certificate_name           = local.appgw_cert_name
  }

  waf_configuration {
    enabled                  = true
    firewall_mode            = "Prevention"
    rule_set_type            = "OWASP"
    rule_set_version         = 3.1
    file_upload_limit_mb     = 100
    max_request_body_size_kb = 128
    request_body_check       = true

  }


  # Add private IP addresses that should be routable by the App GW
  backend_address_pool {
    name = var.appgw_backend_address_pool_name
    #ip_addresses  = var.backend_ip_addresses 
  }

  # Label Studio routing
  backend_http_settings {
    name                  = var.appgw_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  request_routing_rule {
    name                       = var.appgw_request_routing_name
    rule_type                  = "Basic"
    http_listener_name         = var.appgw_https_listener_name
    backend_address_pool_name  = var.appgw_backend_address_pool_name
    backend_http_settings_name = var.appgw_http_setting_name
    priority                   = 1
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


  tags = var.tags
}


resource "azurerm_role_assignment" "ingress_application_gateway_identity" {
  scope                = azurerm_application_gateway.appgw.id
  role_definition_name = "Contributor"
  principal_id         = var.ingress_managed_ingress_identity
}
