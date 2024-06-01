# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

variable "name" {
  type        = string
  description = "Name of the vnet"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the parent resource group"
}

variable "address_space" {
  type        = list(string)
  description = "Address space of the network"
}

variable "location" {
  type        = string
  description = "Location of the vnet"
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with this vnet."
  default     = {}
}

variable "ddos_protection_plan" {
  type        = string
  description = "The Resource ID of DDoS Protection Plan"
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. Changing this forces a new resource to be created."
}
# optional variables are still in experimental phase, so in order to make delegation optional, we have to remove
# the var type definition to allow it accept any value
variable "subnets" {
/*  type =map(object({
    subnet_name = string
    subnet_cidr = list(string)
    service_endpoint = list(string)
    delegation_name = string
    delegation_service = string
    delegation_actions = list(string)}))
*/
  description = <<EOF
    subnet_name: The name of the subnet.
    subnet_cidr: The address prefixes for the subnet.
    service_endpoint: The list of Service endpoints to associate with the subnet.
    delegation_name: A name for this delegation.
    delegation_service: The name of service to delegate to.
    delegation_actions: A list of Actions which should be delegated. This list is specific to the service to delegate to.
  EOF
 default = {
    snet-example-subnet= {
      subnet_name = "snet-example-subnet"
      subnet_cidr = ["10.0.2.0/24"]
      service_endpoint = ["Microsoft.Storage"]
      delegation_name = ""
      delegation_service = ""
      delegation_actions = []
    }
  }
}

variable "logging" {
  description = "Location of the resource group"
  default = [
    {
      name    = "VMProtectionAlerts"
      enabled = true
    },
  ]
}

variable "retention_days" {
  type        = number
  default     = 90
  description = " A retention_policy block as defined below. Zero means infinty"
}

variable "diag_name" {
  type    = string
  default = "diag-settings"
}

variable "metrics_enabled" {
  type    = bool
  default = false
}

variable "mondiag_enabled" {
  type = bool
  default = true
  description = "If Montoring Diagnostic must be activated"
}

variable "enforce_private_link_endpoint" {
  default = false
}
variable "enforce_private_link_service" {
  default = null
}