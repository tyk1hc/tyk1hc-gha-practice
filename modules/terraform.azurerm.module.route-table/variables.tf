variable "name" {
  type        = string
  description = "The name of the route table."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the route table."
}

variable "location" {
  type        = string
  description = "The location/region where the route table is created."
}

variable "routes" {
  type        = list(map(string))
  default     = []
  description = "List of objects that represent the configuration of each route."
  /*ROUTES = [{ name = "", address_prefix = "", next_hop_type = "", next_hop_in_ip_address = "" }]*/
}

variable "subnet_id" {
  type        = string
  default     = ""
}

variable "subnet_association" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}
