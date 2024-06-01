# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "Name of the storage account"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the parent resource group"
}

variable "location" {
  type        = string
  description = "Location of the storage account"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------


variable "tags" {
  type        = map(string)
  description = "The tags to associate with this storage account."
  default     = {}
}

variable "account_kind" {
  type        = string
  description = "Account kind. Valid options are Storage, StorageV2, and BlobStorage."
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = "Account tier. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Type of replication. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "LRS"
}

variable "access_tier" {
  type        = string
  description = "Access tier the storage account. Valid options are Hot and Cool."
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Controls if access is via https only. Valid options are true and false. Must be true for EISA compliance (MSA-AST-01.6, MSA-AST-01.7)."
  default     = "true"
}

variable "custom_domain_name" {
  type        = string
  description = "The Custom Domain Name to use for the Storage Account, which will be validated by Azure."
  default     = null
}

variable "custom_domain_use_subdomain" {
  type        = string
  description = "Should the Custom Domain Name be validated by using indirect CNAME validation?"
  default     = null
}

variable "network_rules_default_action" {
  type        = string
  description = "Specifies the default action of allow or deny when no other rules match. Valid options are 'Deny' or 'Allow'. If not set, the complete public IP address space is allowed."
  default     = "Allow"
}

variable "network_rules_bypass" {
  type        = list(string)
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Default is 'None'"
  default = [
  "None"]
}

variable "network_rules_ip_rules" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format. Depending on use case might be restricted to allow access only from Bosch IP addresses for EISA compliance (MSA-AST-01.4)."
  default     = []
}

variable "network_rules_virtual_network_subnet_ids" {
  type        = list(string)
  description = "A list of resource ids for subnets."
  default     = []
}

variable "identity_type" {
  type        = string
  description = "Specifies the identity type of the Storage Account. At this time the only allowed value is SystemAssigned."
  default     = "SystemAssigned"
}

variable "advanced_threat_protection" {
  type        = bool
  description = "Controls if advanced threat protection is enabled. Valid options are true and false."
  default     = "true"
  # see MSA-AST-01.3
}

variable "enable_soft_delete" {
  type        = bool
  description = "Indicates whether DeleteRetentionPolicy is enabled for the Blob service."
  default     = "false"
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365."
  default     = 7
}

variable "min_tls_version" {
  default = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  default     = false
  description = "Allow or disallow public access to all nested items in the storage account."
}

variable "blob_versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable versioning for blobs in storage containers."
}

variable "is_hns_enabled" {
  type        = bool
  description = "Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365."
  default     = false
}

variable "service_logging" {
  default = [
    { service = "blob", logs = { StorageRead = true, StorageWrite = true, storageDelete = true }, metrics = { Transaction = false } },
  ]
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "if logging to log analytics workspace should be activated"
  default     = ""
}
variable "retention_days" {
  type        = number
  description = "how long to preserve logs in days"
  default     = 90
}

variable "account_logging" {
  default = [
    #{ service = "account", logs = {}, metrics = { Transaction = true } },
  ]
}