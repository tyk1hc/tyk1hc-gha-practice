# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# variable "env" {
#   type        = string
#   description = "Project environment"
# }

# variable "prefix" {
#   type        = string
#   description = "Common name prefix for resources, e.g. project name."
# }

# variable "cert_name" {
#   type = string
# }

# variable "domain_name_label" {
#   type = string

# }

variable "allocation_method" {
  type = string
  default ="Static"
}

variable "location" {
  type        = string
  description = "Location."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to be imported."
}

variable "subnet_id" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#subnet_id"
}


#variable "app_gw_cert_pwd" {
#  type        = string
#  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#password"
#}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "tags" {
  description = "The tags to associate with created resources"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#name"
  default     = "Standard_Small"
}

variable "sku_tier" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#tier"
  default     = "Standard"
}

variable "sku_capacity" {
  type        = number
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#capacity"
  default     = 1
}

variable "backend_ip_addresses" {
  type        = list(string)
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#ip_addresses"
  default     = []
}
variable "appgw_ip_config_name" {
  type= string
  
}
variable "appgw_frontend_port_name" {
  type= string
  
}
variable "appgw_frontend_ip_config_name" {
  type= string
  
}
# variable "min_protocol_version" {
#   type= string
#   description = "The minimal TLS version"
#   default = "TLSv1_2"
  
# }
variable "appgw_backend_address_pool_name" {
  type= string
  
}
variable "appgw_http_setting_name" {
  type= string
  
}
variable "appgw_https_listener_name" {
  type= string
  
}
variable "appgw_request_routing_name" {
  type= string
  
}
variable "appgw_https_port_name" {
  type= string
  
}

variable "public_ip_address_id" {
  type=string
}

variable "ingress_managed_ingress_identity" {
  type=string
}

#####################################################################################################################
#Diagnostic Settings
#####################################################################################################################

# variable "log_analytics_workspace_id" {
#   type        = string
#   description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. Changing this forces a new resource to be created."
# }

# variable "resource_count" {
#   type = string
# }

variable "service_logging" {
  default = []
}

variable "retention_days" {
  type    = string
  default = 90
}

variable "waf_configuration_settings" {
  description = "A map used to configured WAF if defined"
  type        = map(string)
  default     = {}
}






# variable "project" {
#   type = string
# }



# variable "deployment" {
#   type = string
# }

variable "identity_type" {
  type = string
  default = "UserAssigned"
}

variable "identity_ids" {
  type = list(string)
  default = []
}
variable "projectname" {
  default = "stardog"
}

variable "env" {
  default     = "dev"
  description = "Environment prefix"
}
variable "name"{
  type=string
}

