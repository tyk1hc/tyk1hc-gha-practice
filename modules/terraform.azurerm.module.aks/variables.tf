# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

# AKS
variable "name" {
  type        = string
  description = "Base name for resources created by this module. Changing the name on existing resources will force recreation."
}

variable "cluster_suffix" {
  type        = string
  description = "Suffix for the kubernetes cluster created by this module. Add an empty string if no suffix is wanted. Changing the name on existing resources will force recreation."
  default     = "aks"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group for the module resources."
}

variable "aks_resource_group_id" {
  type        = string
  description = "id of the resource group for the module resources."
}

variable "network_resource_group_id" {
  type        = string
  description = "id of the resource group for the module resources."
}
variable "node_resource_group" {
  description = "Name of the resource group where the worked nodes are created by AKS. This is optional."
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes which should be used. It needs to be supported by Azure, see https://docs.microsoft.com/en-us/azure/aks/supported-kubernetes-versions."
  default     = null
}

variable "location" {
  type        = string
  description = "Azure location where to provision the resources created by this module."
}

variable "sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  default     = "Free"
}

variable "private_cluster_enabled" {
  type        = string
  description = "cluster is a private cluster or public cluster"
  default     = "false"
}


variable "private_dns_zone_id" {
  type        = string
  description = "Zone id of the prviate cluster"
  default     = ""
}

variable "private_dns_aks_customdns_vnet" {
  type        = string
  default     = ""
}

variable "private_cluster_public_fqdn_enabled" {
  type        = string
  description = "fqdn is enabled or not"
  default     = "false"
}

variable "automatic_channel_upgrade" {
  type        = string
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable. Defaults to none."
  default     = null
}

variable "maintenance_windows_allowed" {
  type = set(object({
    day   = string
    hours = set(number)
  }))
  description = "Allowed maintenance windows for the AKS cluster."
  default     = []
}

variable "maintenance_windows_not_allowed" {
  type = set(object({
    start = string
    end   = string
  }))
  description = "Time spans, when no maintenance for the AKS cluster should be done. The timestamps should be formatted as an RFC3339 string."
  default     = []
}

variable "aks_user_managed_identity_name" {
  type        = string
  default     = null
}

variable "aks_user_managed_identity_rg" {
  type        = string
  default     = null
}

variable "aks_user_managed_identity_rg_location" {
  type        = string
  default     = null
}
variable "aks_sp_id" {
  type        = string
  description = "Id of the Service Principal for the AKS. This is required if you don't have Owner permissions."
  default     = null
}

variable "aks_sp_secret" {
  type        = string
  description = "Secret for the AKS Service Principal. This is required if you don't have Owner permissions."
  default     = null
}

variable "use_managed_identity" {
  type        = bool
  description = "Flag to explicitly use a managed identity or not to avoid issues with unreliable count."
  default     = null
}

variable "acr_id" {
  type        = string
  description = "Id of your Azure Container Registry."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to add to resources created by this module"
  default     = {}
}
variable "owner_tag" {
  type        = map(string)
  description = "Additional tags to add to resources created by this module"
  default     = {}
}

# Network
variable "network_plugin" {
  type        = string
}

variable "load_balancer_sku" {
  type        = string
}

variable "aks_dns_service_ip" {
  type        = string
}

variable "aks_docker_bridge_cidr" {
  type        = string
}

variable "aks_service_cidr" {
  type        = string
}

variable "aks_pod_cidr" {
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for the AKS."
}

# Agents
variable "agent_name" {
  type        = string
  description = "Unique name of the agent pool profile in the context of the subscription and resource group."
  default     = "minion"
}

variable "node_count" {
  type        = number
  description = "Number of Kubernetes nodes. The node_count for default node pool should be set to null to achieve the same behavior as the ignore_changes block. This only applies if enable_auto_scaling = true"
}

variable "min_count" {
  type        = number
  description = "Min number of kubernetes nodes in default nodepool. This value must be set to null if enable_auto_scaling = false"
  default     = null
}

variable "max_count" {
  type        = number
  description = "Max number of kubernetes nodes in default nodepool.This value must be set to null if enable_auto_scaling = false"
  default     = null
}
variable "enable_auto_scaling" {
  description = "Enable autoscaling for default node pool.The node_count should be set to null to achieve the same behavior as the ignore_changes block"
  type        = bool
  default     = false

}

variable "node_labels" {
  type        = map(string)
  description = "A map of Kubernetes labels which should be applied to nodes in this Node Pool.Changing this forces a new resource to be created"
  default     = {}
}

variable "max_pods" {
  type        = number
  description = "The maximum number of pods that can run on each agent."
  default     = 30
}

variable "vm_size" {
  type        = string
  description = "Size of the VMs."
  default     = "Standard_D4s_v3"
}

variable "node_disk_size" {
  type        = number
  description = "Size of the node disk in GB."
  default     = 30
}

variable "node_disk_type" {
  type        = string
  description = "The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed."
  default     = "Managed"
}

variable "default_node_pool_ultra_ssd_enabled" {
  type        = string
  default     = "false"
}

variable "upgrade_settings" {
  type = object({
    max_surge = string
  })
  default     = null
  description = "The maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for nodes. This requires load_balancer_sku to be standard."
  default     = null
}

variable "linux_profiles" {
  type = object({
    admin_username = string
    ssh_key_data   = string
  })
  description = "Map to configure access for the VMs. The keys are username and keydata for the ssh key."
  default     = null
}

# variable "additional_node_pools" {
#   description = "Map to configure one or several additional node pools. The key of the map is used as the pool name. Since complex default values are only available in terraform 0.15 and later you have to set each attribute according to the comments."
#   type = map(object({
#     node_count                     = number       # number of nodes or initial pool size if autoscaling is enabled.
#     vm_size                        = string       # Size of the VMs in the pool. E.g Standard_D4s_v3
#     availability_zones             = list(string) # Availability zones for nodes. This requires load_balancer_sku to be standard.
#     node_disk_size                 = number       # Size of the node disk in GB.
#     node_disk_type                 = string
#     ultra_ssd_enabled              = bool       # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed.
#     cluster_auto_scaling           = bool         # set to true to enable auto scaling of this node pool
#     cluster_auto_scaling_min_count = number       # minimum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
#     cluster_auto_scaling_max_count = number       # maximum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
#     max_pods                       = number       # configuration of maximum number for the pods per agent pool. Set this to null if cluster_auto_scaling is false.
#     node_labels                    = map(string)  # a map of kubernetes labels which should be applied to nodes in this pool
#     subnet_id                      = string       # own subnet of this node pool, if set to null, the default subnet of the aks will be used
#     owner_tag                      = map(string)    
#     linux_os_config = optional(object({
#       sysctl_config = object({
#         fs_aio_max_nr                      = optional(number) # The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. Changing this forces a new resource to be created.
#         fs_file_max                        = optional(number) # The sysctl setting fs.file-max. Must be between 8192 and 12000500. Changing this forces a new resource to be created.
#         fs_inotify_max_user_watches        = optional(number) # The sysctl setting fs.inotify.max_user_watches. Must be between 781250 and 2097152. Changing this forces a new resource to be created.
#         fs_nr_open                         = optional(number) # The sysctl setting fs.nr_open. Must be between 8192 and 20000500. Changing this forces a new resource to be created.
#         kernel_threads_max                 = optional(number) # The sysctl setting kernel.threads-max. Must be between 20 and 513785. Changing this forces a new resource to be created.
#         net_core_netdev_max_backlog        = optional(number) # The sysctl setting net.core.netdev_max_backlog. Must be between 1000 and 3240000. Changing this forces a new resource to be created.
#         net_core_optmem_max                = optional(number) # The sysctl setting net.core.optmem_max. Must be between 20480 and 4194304. Changing this forces a new resource to be created.
#         net_core_rmem_default              = optional(number) # The sysctl setting net.core.rmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
#         net_core_rmem_max                  = optional(number) # The sysctl setting net.core.rmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
#         net_core_somaxconn                 = optional(number) # The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. Changing this forces a new resource to be created.
#         net_core_wmem_default              = optional(number) # The sysctl setting net.core.wmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
#         net_core_wmem_max                  = optional(number) # The sysctl setting net.core.wmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
#         net_ipv4_ip_local_port_range_max   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range max value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
#         net_ipv4_ip_local_port_range_min   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range min value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
#         net_ipv4_neigh_default_gc_thresh1  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh1. Must be between 128 and 80000. Changing this forces a new resource to be created.
#         net_ipv4_neigh_default_gc_thresh2  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh2. Must be between 512 and 90000. Changing this forces a new resource to be created.
#         net_ipv4_neigh_default_gc_thresh3  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh3. Must be between 1024 and 100000. Changing this forces a new resource to be created.
#         net_ipv4_tcp_fin_timeout           = optional(number) # The sysctl setting net.ipv4.tcp_fin_timeout. Must be between 5 and 120. Changing this forces a new resource to be created.
#         net_ipv4_tcp_keepalive_intvl       = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_intvl. Must be between 10 and 75. Changing this forces a new resource to be created.
#         net_ipv4_tcp_keepalive_probes      = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_probes. Must be between 1 and 15. Changing this forces a new resource to be created.
#         net_ipv4_tcp_keepalive_time        = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_time. Must be between 30 and 432000. Changing this forces a new resource to be created.
#         net_ipv4_tcp_max_syn_backlog       = optional(number) # The sysctl setting net.ipv4.tcp_max_syn_backlog. Must be between 128 and 3240000. Changing this forces a new resource to be created.
#         net_ipv4_tcp_max_tw_buckets        = optional(number) # The sysctl setting net.ipv4.tcp_max_tw_buckets. Must be between 8000 and 1440000. Changing this forces a new resource to be created.
#         net_ipv4_tcp_tw_reuse              = optional(bool)   # The sysctl setting net.ipv4.tcp_tw_reuse. Changing this forces a new resource to be created.
#         net_netfilter_nf_conntrack_buckets = optional(number) # The sysctl setting net.netfilter.nf_conntrack_buckets. Must be between 65536 and 147456. Changing this forces a new resource to be created.
#         net_netfilter_nf_conntrack_max     = optional(number) # The sysctl setting net.netfilter.nf_conntrack_max. Must be between 131072 and 1048576. Changing this forces a new resource to be created.
#         vm_max_map_count                   = optional(number) # The sysctl setting vm.max_map_count. Must be between 65530 and 262144. Changing this forces a new resource to be created.
#         vm_swappiness                      = optional(number) # The sysctl setting vm.swappiness. Must be between 0 and 100. Changing this forces a new resource to be created.
#         vm_vfs_cache_pressure              = optional(number) # The sysctl setting vm.vfs_cache_pressure. Must be between 0 and 100. Changing this forces a new resource to be created.
#       })
#       swap_file_size_mb             = optional(number) # Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created.
#       transparent_huge_page_defrag  = optional(string) # Specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. Changing this forces a new resource to be created.
#       transparent_huge_page_enabled = optional(string) # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. Changing this forces a new resource to be created.
#     }))
#     kubelet_config = optional(object({
#       allowed_unsafe_sysctls    = optional(list(string)) # Specifies the allow list of unsafe sysctls command or patterns (ending in *). Changing this forces a new resource to be created.
#       container_log_max_line    = optional(number)       # Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created.
#       container_log_max_size_mb = optional(number)       # Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created.
#       cpu_cfs_quota_enabled     = optional(bool)         # Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created.
#       cpu_cfs_quota_period      = optional(string)       # Specifies the CPU CFS quota period value. Changing this forces a new resource to be created.
#       cpu_manager_policy        = optional(string)       # Specifies the CPU Manager policy to use. Possible values are none and static, Changing this forces a new resource to be created.
#       image_gc_high_threshold   = optional(number)       # Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. Changing this forces a new resource to be created.#
#       image_gc_low_threshold    = optional(number)       # Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. Changing this forces a new resource to be created.
#       pod_max_pid               = optional(number)       # Specifies the maximum number of processes per pod. Changing this forces a new resource to be created.
#       topology_manager_policy   = optional(string)       # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. Changing this forces a new resource to be created.
#     }))
#   }))
#   default = {}
# }


# Monitoring
variable "law_id" {
  type        = string
  description = "ID of the Log Analytics workspace."
}

variable "law_name" {
  type        = string
  description = "Name of the Log Analytics workspace."
}

variable "command" {
  type        = string
  description = "Name of the Log Analytics workspace."
}

variable "law_rg" {
  type        = string
  description = "Resource group name of the Log Analytics workspace."
}

variable "enable_oms_agent" {
  type        = bool
  default     = true
  description = "Enable monitoring of the AKS cluster"
}

variable "kube_auditlogs_enabled" {
  type        = bool
  default     = true
  description = "Enable kube audit logs. When enabled, the kubeaduit logs will be sent to loganalytics."
}

variable "aks_mds_enabled" {
  type        = bool
  default     = true
  description = "Enable creation of Azure AKS Monitoring diagnostics settings. Default is enabled"
}

# AAD-Integration
variable "managed_azuread" {
  type        = bool
  description = "Flag enable managed Azure AD AKS integration. Should be used where possible as it increases security. Flag is for backwards compatibility. Changing this from true to false forces a new resource to be created."
  default     = true
}

variable "rbac_aad_admin_group_object_ids" {
  type        = list(string)
}

# Key Vault Sync
variable "kvcreds" {
  type = object({
    namespaces    = set(string)
    keyvault_name = string
    keyvault_rg   = string
  })
  description = "Key vault from where the secrets should be synced and a list of namespaces where the secrets should be accessible."
  default     = null
}

variable "policy_sets" {
  type = map(object({
    policy_type  = string
    display_name = string
    description  = string
    policy_definition_references = list(object({
      policy_definition_id = string
      parameters           = string
    }))
  }))
  description = "Configuration settings for enforcing Azure policies on the created cluster."
  default     = {}
}

variable "auto_scaler_profile" {
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

variable "outbound_type" {
  type        = string
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
  default     = "loadBalancer"
}

# Application Gateway Ingress Controller (AGIC)
variable "ingress_application_gateway" {
  description = "Configures Application Gateway Ingress Controller as an AKS add-on. Deactivated by default. Details can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview#benefits-of-application-gateway-ingress-controller"
  type = object({
    enabled    = bool   # Enable Application Gateway Ingress Controller
    gateway_id = string # The ID of the application gateway which will be used as the Ingress Controller
  })
  default = null
}

# Open Service Mesh
variable "open_service_mesh_enabled" {
  description = "Enables the Open Service Mesh (OSM) for the AKS"
  default     = false
  type        = bool
}

# Enable Azure Policy
variable "azure_policy_enabled" {
  type        = bool
  description = "Enable Azure Policy Addon."
  default     = true
}

variable "http_application_routing_enabled" {
  type        = bool
  description = "Enable HTTP Application Routing Addon (forces recreation)."
  default     = false
}

variable "aci_connector_linux_enabled" {
  description = "Enable Virtual Node pool"
  type        = bool
  default     = false
}


variable "azure_keyvault_secrets_provider_enabled" {
  description = "Enable Virtual Node pool"
  type        = bool
  default     = false
}

variable "aci_connector_linux_subnet_name" {
  description = "(Optional) aci_connector_linux subnet name"
  type        = string
  default     = null
}

# Enable RBAC
variable "role_based_access_control_enabled" {
  type        = bool
  description = "Enable Role Based Access Control."
  default     = true
}

######################################
variable "env" {
  type        = string
}



variable "dev_node_pools" {
  description = "Map to configure one or several additional node pools. The key of the map is used as the pool name. Since complex default values are only available in terraform 0.15 and later you have to set each attribute according to the comments."
  type = map(object({
    node_count                     = number       # number of nodes or initial pool size if autoscaling is enabled.
    vm_size                        = string       # Size of the VMs in the pool. E.g Standard_D4s_v3
    availability_zones             = list(string) # Availability zones for nodes. This requires load_balancer_sku to be standard.
    node_disk_size                 = number       # Size of the node disk in GB.
    node_disk_type                 = string
    ultra_ssd_enabled              = bool       # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed.
    cluster_auto_scaling           = bool         # set to true to enable auto scaling of this node pool
    cluster_auto_scaling_min_count = number       # minimum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    cluster_auto_scaling_max_count = number       # maximum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    max_pods                       = number       # configuration of maximum number for the pods per agent pool. Set this to null if cluster_auto_scaling is false.
    node_labels                    = map(string)  # a map of kubernetes labels which should be applied to nodes in this pool
    subnet_id                      = string       # own subnet of this node pool, if set to null, the default subnet of the aks will be used
    owner_tag                      = map(string)
    
    linux_os_config = optional(object({
      sysctl_config = object({
        fs_aio_max_nr                      = optional(number) # The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. Changing this forces a new resource to be created.
        fs_file_max                        = optional(number) # The sysctl setting fs.file-max. Must be between 8192 and 12000500. Changing this forces a new resource to be created.
        fs_inotify_max_user_watches        = optional(number) # The sysctl setting fs.inotify.max_user_watches. Must be between 781250 and 2097152. Changing this forces a new resource to be created.
        fs_nr_open                         = optional(number) # The sysctl setting fs.nr_open. Must be between 8192 and 20000500. Changing this forces a new resource to be created.
        kernel_threads_max                 = optional(number) # The sysctl setting kernel.threads-max. Must be between 20 and 513785. Changing this forces a new resource to be created.
        net_core_netdev_max_backlog        = optional(number) # The sysctl setting net.core.netdev_max_backlog. Must be between 1000 and 3240000. Changing this forces a new resource to be created.
        net_core_optmem_max                = optional(number) # The sysctl setting net.core.optmem_max. Must be between 20480 and 4194304. Changing this forces a new resource to be created.
        net_core_rmem_default              = optional(number) # The sysctl setting net.core.rmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_rmem_max                  = optional(number) # The sysctl setting net.core.rmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_somaxconn                 = optional(number) # The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. Changing this forces a new resource to be created.
        net_core_wmem_default              = optional(number) # The sysctl setting net.core.wmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_wmem_max                  = optional(number) # The sysctl setting net.core.wmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_max   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range max value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_min   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range min value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh1  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh1. Must be between 128 and 80000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh2  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh2. Must be between 512 and 90000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh3  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh3. Must be between 1024 and 100000. Changing this forces a new resource to be created.
        net_ipv4_tcp_fin_timeout           = optional(number) # The sysctl setting net.ipv4.tcp_fin_timeout. Must be between 5 and 120. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_intvl       = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_intvl. Must be between 10 and 75. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_probes      = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_probes. Must be between 1 and 15. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_time        = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_time. Must be between 30 and 432000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_syn_backlog       = optional(number) # The sysctl setting net.ipv4.tcp_max_syn_backlog. Must be between 128 and 3240000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_tw_buckets        = optional(number) # The sysctl setting net.ipv4.tcp_max_tw_buckets. Must be between 8000 and 1440000. Changing this forces a new resource to be created.
        net_ipv4_tcp_tw_reuse              = optional(bool)   # The sysctl setting net.ipv4.tcp_tw_reuse. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_buckets = optional(number) # The sysctl setting net.netfilter.nf_conntrack_buckets. Must be between 65536 and 147456. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_max     = optional(number) # The sysctl setting net.netfilter.nf_conntrack_max. Must be between 131072 and 1048576. Changing this forces a new resource to be created.
        vm_max_map_count                   = optional(number) # The sysctl setting vm.max_map_count. Must be between 65530 and 262144. Changing this forces a new resource to be created.
        vm_swappiness                      = optional(number) # The sysctl setting vm.swappiness. Must be between 0 and 100. Changing this forces a new resource to be created.
        vm_vfs_cache_pressure              = optional(number) # The sysctl setting vm.vfs_cache_pressure. Must be between 0 and 100. Changing this forces a new resource to be created.
      })
      swap_file_size_mb             = optional(number) # Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created.
      transparent_huge_page_defrag  = optional(string) # Specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. Changing this forces a new resource to be created.
      transparent_huge_page_enabled = optional(string) # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. Changing this forces a new resource to be created.
    }))
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(list(string)) # Specifies the allow list of unsafe sysctls command or patterns (ending in *). Changing this forces a new resource to be created.
      container_log_max_line    = optional(number)       # Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created.
      container_log_max_size_mb = optional(number)       # Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created.
      cpu_cfs_quota_enabled     = optional(bool)         # Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created.
      cpu_cfs_quota_period      = optional(string)       # Specifies the CPU CFS quota period value. Changing this forces a new resource to be created.
      cpu_manager_policy        = optional(string)       # Specifies the CPU Manager policy to use. Possible values are none and static, Changing this forces a new resource to be created.
      image_gc_high_threshold   = optional(number)       # Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. Changing this forces a new resource to be created.#
      image_gc_low_threshold    = optional(number)       # Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. Changing this forces a new resource to be created.
      pod_max_pid               = optional(number)       # Specifies the maximum number of processes per pod. Changing this forces a new resource to be created.
      topology_manager_policy   = optional(string)       # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. Changing this forces a new resource to be created.
    }))
  }))
  default = {}
}






variable "qa_node_pools" {
  description = "Map to configure one or several additional node pools. The key of the map is used as the pool name. Since complex default values are only available in terraform 0.15 and later you have to set each attribute according to the comments."
  type = map(object({
    node_count                     = number       # number of nodes or initial pool size if autoscaling is enabled.
    vm_size                        = string       # Size of the VMs in the pool. E.g Standard_D4s_v3
    availability_zones             = list(string) # Availability zones for nodes. This requires load_balancer_sku to be standard.
    node_disk_size                 = number       # Size of the node disk in GB.
    node_disk_type                 = string
    ultra_ssd_enabled              = bool       # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed.
    cluster_auto_scaling           = bool         # set to true to enable auto scaling of this node pool
    cluster_auto_scaling_min_count = number       # minimum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    cluster_auto_scaling_max_count = number       # maximum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    max_pods                       = number       # configuration of maximum number for the pods per agent pool. Set this to null if cluster_auto_scaling is false.
    node_labels                    = map(string)  # a map of kubernetes labels which should be applied to nodes in this pool
    subnet_id                      = string       # own subnet of this node pool, if set to null, the default subnet of the aks will be used
    owner_tag                      = map(string)    
    linux_os_config = optional(object({
      sysctl_config = object({
        fs_aio_max_nr                      = optional(number) # The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. Changing this forces a new resource to be created.
        fs_file_max                        = optional(number) # The sysctl setting fs.file-max. Must be between 8192 and 12000500. Changing this forces a new resource to be created.
        fs_inotify_max_user_watches        = optional(number) # The sysctl setting fs.inotify.max_user_watches. Must be between 781250 and 2097152. Changing this forces a new resource to be created.
        fs_nr_open                         = optional(number) # The sysctl setting fs.nr_open. Must be between 8192 and 20000500. Changing this forces a new resource to be created.
        kernel_threads_max                 = optional(number) # The sysctl setting kernel.threads-max. Must be between 20 and 513785. Changing this forces a new resource to be created.
        net_core_netdev_max_backlog        = optional(number) # The sysctl setting net.core.netdev_max_backlog. Must be between 1000 and 3240000. Changing this forces a new resource to be created.
        net_core_optmem_max                = optional(number) # The sysctl setting net.core.optmem_max. Must be between 20480 and 4194304. Changing this forces a new resource to be created.
        net_core_rmem_default              = optional(number) # The sysctl setting net.core.rmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_rmem_max                  = optional(number) # The sysctl setting net.core.rmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_somaxconn                 = optional(number) # The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. Changing this forces a new resource to be created.
        net_core_wmem_default              = optional(number) # The sysctl setting net.core.wmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_wmem_max                  = optional(number) # The sysctl setting net.core.wmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_max   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range max value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_min   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range min value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh1  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh1. Must be between 128 and 80000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh2  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh2. Must be between 512 and 90000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh3  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh3. Must be between 1024 and 100000. Changing this forces a new resource to be created.
        net_ipv4_tcp_fin_timeout           = optional(number) # The sysctl setting net.ipv4.tcp_fin_timeout. Must be between 5 and 120. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_intvl       = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_intvl. Must be between 10 and 75. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_probes      = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_probes. Must be between 1 and 15. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_time        = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_time. Must be between 30 and 432000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_syn_backlog       = optional(number) # The sysctl setting net.ipv4.tcp_max_syn_backlog. Must be between 128 and 3240000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_tw_buckets        = optional(number) # The sysctl setting net.ipv4.tcp_max_tw_buckets. Must be between 8000 and 1440000. Changing this forces a new resource to be created.
        net_ipv4_tcp_tw_reuse              = optional(bool)   # The sysctl setting net.ipv4.tcp_tw_reuse. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_buckets = optional(number) # The sysctl setting net.netfilter.nf_conntrack_buckets. Must be between 65536 and 147456. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_max     = optional(number) # The sysctl setting net.netfilter.nf_conntrack_max. Must be between 131072 and 1048576. Changing this forces a new resource to be created.
        vm_max_map_count                   = optional(number) # The sysctl setting vm.max_map_count. Must be between 65530 and 262144. Changing this forces a new resource to be created.
        vm_swappiness                      = optional(number) # The sysctl setting vm.swappiness. Must be between 0 and 100. Changing this forces a new resource to be created.
        vm_vfs_cache_pressure              = optional(number) # The sysctl setting vm.vfs_cache_pressure. Must be between 0 and 100. Changing this forces a new resource to be created.
      })
      swap_file_size_mb             = optional(number) # Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created.
      transparent_huge_page_defrag  = optional(string) # Specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. Changing this forces a new resource to be created.
      transparent_huge_page_enabled = optional(string) # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. Changing this forces a new resource to be created.
    }))
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(list(string)) # Specifies the allow list of unsafe sysctls command or patterns (ending in *). Changing this forces a new resource to be created.
      container_log_max_line    = optional(number)       # Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created.
      container_log_max_size_mb = optional(number)       # Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created.
      cpu_cfs_quota_enabled     = optional(bool)         # Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created.
      cpu_cfs_quota_period      = optional(string)       # Specifies the CPU CFS quota period value. Changing this forces a new resource to be created.
      cpu_manager_policy        = optional(string)       # Specifies the CPU Manager policy to use. Possible values are none and static, Changing this forces a new resource to be created.
      image_gc_high_threshold   = optional(number)       # Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. Changing this forces a new resource to be created.#
      image_gc_low_threshold    = optional(number)       # Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. Changing this forces a new resource to be created.
      pod_max_pid               = optional(number)       # Specifies the maximum number of processes per pod. Changing this forces a new resource to be created.
      topology_manager_policy   = optional(string)       # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. Changing this forces a new resource to be created.
    }))
  }))
  default = {}
}




variable "prod_node_pools" {
  description = "Map to configure one or several additional node pools. The key of the map is used as the pool name. Since complex default values are only available in terraform 0.15 and later you have to set each attribute according to the comments."
  type = map(object({
    node_count                     = number       # number of nodes or initial pool size if autoscaling is enabled.
    vm_size                        = string       # Size of the VMs in the pool. E.g Standard_D4s_v3
    availability_zones             = list(string) # Availability zones for nodes. This requires load_balancer_sku to be standard.
    node_disk_size                 = number       # Size of the node disk in GB.
    node_disk_type                 = string
    ultra_ssd_enabled              = bool       # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed.
    cluster_auto_scaling           = bool         # set to true to enable auto scaling of this node pool
    cluster_auto_scaling_min_count = number       # minimum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    cluster_auto_scaling_max_count = number       # maximum number of nodes in the cluster if autoscaling is enabled. Set this to null if cluster_auto_scaling is false.
    max_pods                       = number       # configuration of maximum number for the pods per agent pool. Set this to null if cluster_auto_scaling is false.
    node_labels                    = map(string)  # a map of kubernetes labels which should be applied to nodes in this pool
    subnet_id                      = string       # own subnet of this node pool, if set to null, the default subnet of the aks will be used
    owner_tag                      = map(string)    
    linux_os_config = optional(object({
      sysctl_config = object({
        fs_aio_max_nr                      = optional(number) # The sysctl setting fs.aio-max-nr. Must be between 65536 and 6553500. Changing this forces a new resource to be created.
        fs_file_max                        = optional(number) # The sysctl setting fs.file-max. Must be between 8192 and 12000500. Changing this forces a new resource to be created.
        fs_inotify_max_user_watches        = optional(number) # The sysctl setting fs.inotify.max_user_watches. Must be between 781250 and 2097152. Changing this forces a new resource to be created.
        fs_nr_open                         = optional(number) # The sysctl setting fs.nr_open. Must be between 8192 and 20000500. Changing this forces a new resource to be created.
        kernel_threads_max                 = optional(number) # The sysctl setting kernel.threads-max. Must be between 20 and 513785. Changing this forces a new resource to be created.
        net_core_netdev_max_backlog        = optional(number) # The sysctl setting net.core.netdev_max_backlog. Must be between 1000 and 3240000. Changing this forces a new resource to be created.
        net_core_optmem_max                = optional(number) # The sysctl setting net.core.optmem_max. Must be between 20480 and 4194304. Changing this forces a new resource to be created.
        net_core_rmem_default              = optional(number) # The sysctl setting net.core.rmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_rmem_max                  = optional(number) # The sysctl setting net.core.rmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_somaxconn                 = optional(number) # The sysctl setting net.core.somaxconn. Must be between 4096 and 3240000. Changing this forces a new resource to be created.
        net_core_wmem_default              = optional(number) # The sysctl setting net.core.wmem_default. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_core_wmem_max                  = optional(number) # The sysctl setting net.core.wmem_max. Must be between 212992 and 134217728. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_max   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range max value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_min   = optional(number) # The sysctl setting net.ipv4.ip_local_port_range min value. Must be between 1024 and 60999. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh1  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh1. Must be between 128 and 80000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh2  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh2. Must be between 512 and 90000. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh3  = optional(number) # The sysctl setting net.ipv4.neigh.default.gc_thresh3. Must be between 1024 and 100000. Changing this forces a new resource to be created.
        net_ipv4_tcp_fin_timeout           = optional(number) # The sysctl setting net.ipv4.tcp_fin_timeout. Must be between 5 and 120. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_intvl       = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_intvl. Must be between 10 and 75. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_probes      = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_probes. Must be between 1 and 15. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_time        = optional(number) # The sysctl setting net.ipv4.tcp_keepalive_time. Must be between 30 and 432000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_syn_backlog       = optional(number) # The sysctl setting net.ipv4.tcp_max_syn_backlog. Must be between 128 and 3240000. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_tw_buckets        = optional(number) # The sysctl setting net.ipv4.tcp_max_tw_buckets. Must be between 8000 and 1440000. Changing this forces a new resource to be created.
        net_ipv4_tcp_tw_reuse              = optional(bool)   # The sysctl setting net.ipv4.tcp_tw_reuse. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_buckets = optional(number) # The sysctl setting net.netfilter.nf_conntrack_buckets. Must be between 65536 and 147456. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_max     = optional(number) # The sysctl setting net.netfilter.nf_conntrack_max. Must be between 131072 and 1048576. Changing this forces a new resource to be created.
        vm_max_map_count                   = optional(number) # The sysctl setting vm.max_map_count. Must be between 65530 and 262144. Changing this forces a new resource to be created.
        vm_swappiness                      = optional(number) # The sysctl setting vm.swappiness. Must be between 0 and 100. Changing this forces a new resource to be created.
        vm_vfs_cache_pressure              = optional(number) # The sysctl setting vm.vfs_cache_pressure. Must be between 0 and 100. Changing this forces a new resource to be created.
      })
      swap_file_size_mb             = optional(number) # Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created.
      transparent_huge_page_defrag  = optional(string) # Specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never. Changing this forces a new resource to be created.
      transparent_huge_page_enabled = optional(string) # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never. Changing this forces a new resource to be created.
    }))
    kubelet_config = optional(object({
      allowed_unsafe_sysctls    = optional(list(string)) # Specifies the allow list of unsafe sysctls command or patterns (ending in *). Changing this forces a new resource to be created.
      container_log_max_line    = optional(number)       # Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created.
      container_log_max_size_mb = optional(number)       # Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created.
      cpu_cfs_quota_enabled     = optional(bool)         # Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created.
      cpu_cfs_quota_period      = optional(string)       # Specifies the CPU CFS quota period value. Changing this forces a new resource to be created.
      cpu_manager_policy        = optional(string)       # Specifies the CPU Manager policy to use. Possible values are none and static, Changing this forces a new resource to be created.
      image_gc_high_threshold   = optional(number)       # Specifies the percent of disk usage above which image garbage collection is always run. Must be between 0 and 100. Changing this forces a new resource to be created.#
      image_gc_low_threshold    = optional(number)       # Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between 0 and 100. Changing this forces a new resource to be created.
      pod_max_pid               = optional(number)       # Specifies the maximum number of processes per pod. Changing this forces a new resource to be created.
      topology_manager_policy   = optional(string)       # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node. Changing this forces a new resource to be created.
    }))
  }))
  default = {}
}