


data azurerm_subscription current  {}


resource "azurerm_public_ip" "firewallip" {
  name                = "${var.name}-fw-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge(var.tags, local.common_tags)
  zones               = var.fw_public_ip_availability_zones
}

resource "azurerm_firewall_policy" "aks-firewallpolicy" {
  name                = "${var.name}-fwpolicy"
  resource_group_name = azurerm_public_ip.firewallip.resource_group_name
  location            = azurerm_public_ip.firewallip.location
  dns {
    proxy_enabled = true
  }
  tags = merge(var.tags, local.common_tags)
}

resource "azurerm_firewall" "firewall" {
  name                = "${var.name}-fw"
  resource_group_name = azurerm_public_ip.firewallip.resource_group_name
  location            = azurerm_public_ip.firewallip.location
  firewall_policy_id  = azurerm_firewall_policy.aks-firewallpolicy.id
  sku_name            = var.fw_sku_name
  sku_tier            = var.fw_sku_tier
  ip_configuration {
    name                 = "${var.name}-ip"
    subnet_id            = var.subnet
    public_ip_address_id = azurerm_public_ip.firewallip.id
  }
  tags = merge(var.tags, local.common_tags)
}



resource "azurerm_firewall_policy_rule_collection_group" "fw-initial-rool" {
  name               = "${var.name}-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.aks-firewallpolicy.id
  priority           = 500

  application_rule_collection {

         name = "app_rule_collection1"
         priority = 500
         action = "Allow"
         dynamic "rule" {
           for_each = var.apprules
           content {
           name = rule.value["name"]
           dynamic "protocols" {
                for_each = rule.value["protocols"]
                content {
                    type = protocols.value["type"]
                    port = protocols.value["port"]
                }
           }
           source_addresses = rule.value["source_addresses"]
           destination_fqdn_tags = rule.value["destination_fqdn_tags"]
           }
         }    
    }

    network_rule_collection {

          name = "network_rule_collection1"
          priority = 400
          action = "Allow"
          dynamic "rule" {
            for_each = var.nwrules
            content {
              name = rule.value["name"]
              protocols = rule.value["protocols"]
              source_addresses = rule.value["source_addresses"]
              destination_addresses = rule.value["destination_addresses"]
              destination_ports = rule.value["destination_ports"]
              destination_fqdns = rule.value["destination_fqdns"]
            }
          }
    }

}


