variable "private_endpoint_name" {
type = string  
}

variable "private_service_connection_name" {
type = string  
}

variable "private_dns_name" {
type = string  
}

variable "location" {
}

variable "tags" {
}


variable "resource_group_name" {
type = string  
}



variable "subnet_id" {
  type = string
  default = ""
}

variable "subresource_names" {
  type = list(string)
  default = []
}

variable "private_connection_resource_id" {
  type = string
}

variable "approval_message" {
  type = string
  default = "created by terraform"
}

#############Private DNS###############################



# variable "private_dns_zone_group" {
 
#   type = object({
#     name                 = string
#     private_dns_zone_ids = list(string)
#   })
#   default = null
# }

variable "private_dns_zone_ids" {
  type = list(string)  
}
