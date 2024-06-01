variable "resource_group_name" {
type = string  
}

variable "dns_zone_name" {
  type = string
  default  = "privatelink.blob.core.windows.net"
}

variable "private_dns_zone_virtual_network_link_name" {
type = string  
}


variable "vnet_id" {
  type = string
}

variable "location" {
}

variable "tags" {
}
