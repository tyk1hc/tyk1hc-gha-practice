# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

locals {
  module_tags = {
    creator             = "terraform"
    module_name         = "terraform.azurerm.module.aks"
    module_version      = file("${path.module}/RELEASE")
    terraform_workspace = terraform.workspace
  }

  tags = merge(local.module_tags, var.tags)
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                              = var.cluster_suffix == "" ? var.name : "${var.name}-${var.cluster_suffix}"
  location                          = var.location
  resource_group_name               = var.resource_group_name
  azure_policy_enabled              = var.azure_policy_enabled
  http_application_routing_enabled  = var.http_application_routing_enabled
  node_resource_group               = var.node_resource_group
  kubernetes_version                = var.kubernetes_version
  dns_prefix                        = var.name
  sku_tier                          = var.sku_tier
  automatic_channel_upgrade         = var.automatic_channel_upgrade
  open_service_mesh_enabled         = var.open_service_mesh_enabled
  private_cluster_enabled           = var.private_cluster_enabled
  private_dns_zone_id               = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  dynamic "maintenance_window" {
    for_each = length(var.maintenance_windows_allowed) == 0 && length(var.maintenance_windows_not_allowed) == 0 ? [] : [""]
    content {
      dynamic "allowed" {
        for_each = var.maintenance_windows_allowed
        content {
          day   = allowed.value["day"]
          hours = allowed.value["hours"]
        }
      }

      dynamic "not_allowed" {
        for_each = var.maintenance_windows_not_allowed
        content {
          start = not_allowed.value["start"]
          end   = not_allowed.value["end"]
        }
      }
    }
  }

  default_node_pool {
    temporary_name_for_rotation = "demand"
    name                 = var.agent_name
    vm_size              = var.vm_size
    node_count           = var.node_count
    enable_auto_scaling  = var.enable_auto_scaling
    min_count            = var.min_count
    max_count            = var.max_count
    node_labels          = var.node_labels
    max_pods             = var.max_pods
    os_disk_size_gb      = var.node_disk_size
    os_disk_type         = var.node_disk_type
    ultra_ssd_enabled    = var.default_node_pool_ultra_ssd_enabled
    vnet_subnet_id       = var.subnet_id
    type                 = "VirtualMachineScaleSets"
    zones                = var.availability_zones
    orchestrator_version = var.kubernetes_version
    tags                 = local.tags
    dynamic "upgrade_settings" {
      for_each = var.upgrade_settings != null ? [var.upgrade_settings] : []
      content {
        max_surge = var.upgrade_settings.max_surge
      }
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = var.auto_scaler_profile.balance_similar_node_groups
    max_graceful_termination_sec     = var.auto_scaler_profile.max_graceful_termination_sec
    new_pod_scale_up_delay           = var.auto_scaler_profile.new_pod_scale_up_delay
    scale_down_delay_after_add       = var.auto_scaler_profile.scale_down_delay_after_add
    scale_down_delay_after_delete    = var.auto_scaler_profile.scale_down_delay_after_delete
    scale_down_delay_after_failure   = var.auto_scaler_profile.scale_down_delay_after_failure
    scan_interval                    = var.auto_scaler_profile.scan_interval
    scale_down_unneeded              = var.auto_scaler_profile.scale_down_unneeded
    scale_down_unready               = var.auto_scaler_profile.scale_down_unready
    scale_down_utilization_threshold = var.auto_scaler_profile.scale_down_utilization_threshold
    skip_nodes_with_local_storage    = var.auto_scaler_profile.skip_nodes_with_local_storage
    skip_nodes_with_system_pods      = var.auto_scaler_profile.skip_nodes_with_system_pods     
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_user_managed_identity.id]
  }

  network_profile {
    network_plugin     = var.network_plugin
    load_balancer_sku  = var.load_balancer_sku
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
    pod_cidr           = var.aks_pod_cidr
    outbound_type      = "userDefinedRouting"
  }

  monitor_metrics {
    annotations_allowed = "monitor_metrics.0.annotations_allowed"
    labels_allowed = "monitor_metrics.0.labels_allowed"
  }

  dynamic "linux_profile" {
    for_each = var.linux_profiles == null ? [] : [var.linux_profiles]
    content {
      admin_username = linux_profile.value.admin_username
      ssh_key {
        key_data = linux_profile.value.ssh_key_data
      }
    }
  }

  dynamic "oms_agent" {
    for_each = var.enable_oms_agent ? ["oms_agent"] : []
    content {
      log_analytics_workspace_id = var.law_id
    }
  }
  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway == null ? [] : [var.ingress_application_gateway]
    content {
      gateway_id = var.ingress_application_gateway.gateway_id
    }
  }

  dynamic "aci_connector_linux" {
    for_each = var.aci_connector_linux_enabled ? ["aci_connector_linux"] : []

    content {
      subnet_name = var.aci_connector_linux_subnet_name
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = var.azure_keyvault_secrets_provider_enabled
  }

#  role_based_access_control_enabled {
    # enabled = true
    azure_active_directory_role_based_access_control {
      managed                = true
      admin_group_object_ids = var.rbac_aad_admin_group_object_ids
      azure_rbac_enabled     = true
    }

  # }

  lifecycle {
    ignore_changes = [
      windows_profile,
      default_node_pool,microsoft_defender

    ]
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

 #for_each = var.additional_node_pools == null ? {} : var.additional_node_pools
  #for_each = var.env == "qa" || var.env == "prod" ? (var.additional_node_pools == null ? {} : var.additional_node_pools) : var.dev_node_pools
  for_each = var.env == "qa" ? coalesce(var.qa_node_pools, var.dev_node_pools) : var.env == "prod" ? coalesce(var.prod_node_pools, var.dev_node_pools) : var.dev_node_pools


  tags = merge(local.module_tags,each.value.owner_tag)

  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
  name                  = each.key
  orchestrator_version  = var.kubernetes_version
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  os_disk_size_gb       = each.value.node_disk_size
  os_disk_type          = each.value.node_disk_type
  node_labels           = each.value.node_labels
  vnet_subnet_id        = each.value.subnet_id == null ? var.subnet_id : each.value.subnet_id
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  max_pods              = each.value.max_pods
  zones                 =  each.value.availability_zones
  ultra_ssd_enabled     = each.value.ultra_ssd_enabled
  dynamic "upgrade_settings" {
    for_each = var.upgrade_settings != null ? [var.upgrade_settings] : []
    content {
      max_surge = var.upgrade_settings.max_surge
    }
  }
  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config == null ? [] : tolist([each.value.linux_os_config])
    content {
      dynamic "sysctl_config" {
        for_each = lookup(linux_os_config.value, "sysctl_config", null) == null ? [] : tolist([linux_os_config.value.sysctl_config])
        content {
          fs_aio_max_nr                      = lookup(sysctl_config.value, "fs_aio_max_nr", null)
          fs_file_max                        = lookup(sysctl_config.value, "fs_file_max", null)
          fs_inotify_max_user_watches        = lookup(sysctl_config.value, "fs_inotify_max_user_watches", null)
          fs_nr_open                         = lookup(sysctl_config.value, "fs_nr_open", null)
          kernel_threads_max                 = lookup(sysctl_config.value, "kernel_threads_max", null)
          net_core_netdev_max_backlog        = lookup(sysctl_config.value, "net_core_netdev_max_backlog", null)
          net_core_optmem_max                = lookup(sysctl_config.value, "net_core_optmem_max", null)
          net_core_rmem_default              = lookup(sysctl_config.value, "net_core_rmem_default", null)
          net_core_rmem_max                  = lookup(sysctl_config.value, "net_core_rmem_max", null)
          net_core_somaxconn                 = lookup(sysctl_config.value, "net_core_somaxconn", null)
          net_core_wmem_default              = lookup(sysctl_config.value, "net_core_wmem_default", null)
          net_core_wmem_max                  = lookup(sysctl_config.value, "net_core_wmem_max", null)
          net_ipv4_ip_local_port_range_max   = lookup(sysctl_config.value, "net_ipv4_ip_local_port_range_max", null)
          net_ipv4_ip_local_port_range_min   = lookup(sysctl_config.value, "net_ipv4_ip_local_port_range_min", null)
          net_ipv4_neigh_default_gc_thresh1  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh1", null)
          net_ipv4_neigh_default_gc_thresh2  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh2", null)
          net_ipv4_neigh_default_gc_thresh3  = lookup(sysctl_config.value, "net_ipv4_neigh_default_gc_thresh3", null)
          net_ipv4_tcp_fin_timeout           = lookup(sysctl_config.value, "net_ipv4_tcp_fin_timeout", null)
          net_ipv4_tcp_keepalive_intvl       = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_intvl", null)
          net_ipv4_tcp_keepalive_probes      = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_probes", null)
          net_ipv4_tcp_keepalive_time        = lookup(sysctl_config.value, "net_ipv4_tcp_keepalive_time", null)
          net_ipv4_tcp_max_syn_backlog       = lookup(sysctl_config.value, "net_ipv4_tcp_max_syn_backlog", null)
          net_ipv4_tcp_max_tw_buckets        = lookup(sysctl_config.value, "net_ipv4_tcp_max_tw_buckets", null)
          net_ipv4_tcp_tw_reuse              = lookup(sysctl_config.value, "net_ipv4_tcp_tw_reuse", null)
          net_netfilter_nf_conntrack_buckets = lookup(sysctl_config.value, "net_netfilter_nf_conntrack_buckets", null)
          net_netfilter_nf_conntrack_max     = lookup(sysctl_config.value, "net_netfilter_nf_conntrack_max", null)
          vm_max_map_count                   = lookup(sysctl_config.value, "vm_max_map_count", null)
          vm_swappiness                      = lookup(sysctl_config.value, "vm_swappiness", null)
          vm_vfs_cache_pressure              = lookup(sysctl_config.value, "vm_vfs_cache_pressure", null)

        }
      }
      swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
      transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
      transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled
    }
  }
  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config == null ? [] : tolist([each.value.kubelet_config])
    content {
      allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
      container_log_max_line    = kubelet_config.value.container_log_max_line
      container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
      cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
      cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
      image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
      image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
      pod_max_pid               = kubelet_config.value.pod_max_pid
      topology_manager_policy   = kubelet_config.value.topology_manager_policy
    }
  }

    provisioner "local-exec" {
    command = var.command

}
}

resource "azurerm_user_assigned_identity" "aks_user_managed_identity" {
  resource_group_name = var.aks_user_managed_identity_rg
  location            = var.aks_user_managed_identity_rg_location
  name                = var.aks_user_managed_identity_name
}

resource "azurerm_role_assignment" "aks_managed_identity_role_assignment_aks_rg" {
  scope                = var.aks_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_user_managed_identity.principal_id
}

resource "azurerm_role_assignment" "aks_managed_identity_role_assignment_privatednszone" {
  scope                = var.private_dns_aks_customdns_vnet
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_user_managed_identity.principal_id
}



resource "azurerm_role_assignment" "aks_managed_identity_role_assignment_acr" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_user_assigned_identity.aks_user_managed_identity.principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  count                 = var.enable_oms_agent ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.law_rg
  workspace_resource_id = var.law_id
  workspace_name        = var.law_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

data "azurerm_monitor_diagnostic_categories" "aks" {
  count       = var.aks_mds_enabled ? 1 : 0
  resource_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
}

resource "azurerm_monitor_diagnostic_setting" "aks_mds" {
  count                          = var.aks_mds_enabled ? 1 : 0
  lifecycle {
    ignore_changes = [log_analytics_destination_type,metric,log]  # needed as long as this bug is not resolved: https://github.com/hashicorp/terraform-provider-azurerm/issues/17779
  }
  name                           = "diagnostic-settings-logs"
  target_resource_id             = azurerm_kubernetes_cluster.kubernetes_cluster.id
  log_analytics_workspace_id     = var.law_id

  log {
    category = "kube-audit"
    enabled  = var.kube_auditlogs_enabled

    retention_policy {
      enabled = true
      days    = 0
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-apiserver"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "guard"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cloud-controller-manager"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "csi-azuredisk-controller"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "csi-azurefile-controller"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "csi-snapshot-controller"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.aks[0].metrics
    content {
      category = metric.value
      enabled  = false

      retention_policy {
        enabled = false
      }
    }
  }
}

resource "azurerm_policy_set_definition" "kubernetes_policy_set" {
  for_each     = var.policy_sets
  name         = each.key
  policy_type  = each.value.policy_type
  display_name = each.value.display_name

  dynamic "policy_definition_reference" {
    for_each = each.value.policy_definition_references
    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = policy_definition_reference.value.parameters
    }
  }
}

resource "azurerm_resource_policy_assignment" "kubernetes_policy_set_assignment" {
  for_each             = var.policy_sets
  name                 = each.key
  resource_id          = azurerm_kubernetes_cluster.kubernetes_cluster.id
  policy_definition_id = azurerm_policy_set_definition.kubernetes_policy_set[each.key].id
  description          = each.value.description
  display_name         = each.value.display_name
}
