variable "name" {}

variable "location" {}

variable "subnet" {}

variable "resource_group_name" {}

variable "tags" {}
variable "fw_sku_name"{
    type=string
}
variable "fw_sku_tier"{
    type=string
}

variable "fw_public_ip_availability_zones"{
    type= list(string)
}


variable "apprules" {
    type =  list(object({
        name = string
        source_addresses = list(string)
        destination_fqdn_tags = list(string)
        protocols = list(object({ 
            type = string
            port = number
            }))
        }))
}

variable "nwrules" {
    type =  list(object({
        name = string
        protocols = list(string)
        source_addresses = list(string)
        destination_addresses = list(string)
        destination_ports = list(number)
        destination_fqdns = list(string)
        }))
}