# Project  Name
variable "ProjectName" {
  type        = string
  default     = "ttky"
  description = "Project Name"
}

# Environment
variable "ProjectEnvironment" {
  type = map(string)
  default = {
    "Development" = "dev",
    "Quality"     = "qa",
    "Production"  = "pro"
  }
  description = "Environment value"
}

# Location
variable "Location" {
  type        = string
  default     = "southeastasia"
  description = "The Azure Region in which all resources should be provisioned"
}


# --- Azure Resource Types ---
variable "AzureResourceTypes" {
  type = map(string)
  default = {
    ResourceGroup  = "rg"
    VirtualNetwork = "vnet"
    LogAnalyticWorkSpace = "log"
    NetworkSecurityGroup = "nsg"
    ContainerRegistry = "cr"
    StorageAccount = "st"
    ApplicationGateway = "agw"
    AzureKubernetes= "aks"
    PrivateDomainNameServer = "dns"
    PrivateLinkDomainNameServer = "pr-dns"

  }
  description = "The Azure Resource Group Type Abbreviation"
}

# --- Azure Virtual Network ---
variable "vnet_default_address_spaces" {
  type = string
  default = "10.0.0.0/16"
  description = "The default virtual network address spaces"
}

variable "subnet_common_address_spaces" {
  type = string
  default = "10.0.1.0/24"
  description = "The common address spaces"
}

variable "subnet_app_gateway_address_spaces" {
  type = string
  default = "10.0.2.0/24"
  description = "The application gateway address spaces"
}

variable "subnet_aks_address_spaces" {
  type = string
  default = "10.0.192.0/18"
  description = "The AKS address spaces"
}

variable "aks_auto_scaler_profile" {
  type = object({
    balance_similar_node_groups      = optional(bool,true)   # Detect similar node groups and balance the number of nodes between them
    max_graceful_termination_sec     = optional(string,"600") # Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node
    new_pod_scale_up_delay           = optional(string,"10s") # For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age
    scale_down_delay_after_add       = optional(string,"10m") # How long after the scale up of AKS nodes the scale down evaluation resumes
    scale_down_delay_after_delete    = optional(string,"10s") # How long after node deletion that scale down evaluation resumes
    scale_down_delay_after_failure   = optional(string,"3m") # How long after scale down failure that scale down evaluation resumes
    scan_interval                    = optional(string,"10s") # How often the AKS Cluster should be re-evaluated for scale up/down
    scale_down_unneeded              = optional(string,"10m") # How long a node should be unneeded before it is eligible for scale down
    scale_down_unready               = optional(string,"20m") # How long an unready node should be unneeded before it is eligible for scale down
    scale_down_utilization_threshold = optional(string,"0.5") # Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down
    skip_nodes_with_local_storage    = optional(bool,true) # If true cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath. Defaults to true
    skip_nodes_with_system_pods      = optional(bool,true) # If true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods). Defaults to true.
  })

  default = {
    balance_similar_node_groups      = true
    max_graceful_termination_sec     = "600"
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_unneeded              = "10m"
    scale_down_unready               = "20m"
    scale_down_utilization_threshold = "0.5"
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true

  }
}