resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
    name = "${local.Project}-${var.AzureResourceTypes["AzureKubernetes"]}-aks-test-${local.Environment}"
    location                          = local.Location
    resource_group_name               = azurerm_resource_group.resource-group-virtual-network
    azure_policy_enabled              = "true"
    http_application_routing_enabled  = "true"
    node_resource_group               = "${local.Project}-${var.AzureResourceTypes["ResourceGroup"]}-aks-nodes-${local.Environment}"
    kubernetes_version                = "1.28.9"
    #dns_prefix                        = var.name
    sku_tier                          = "Free"
    automatic_channel_upgrade         = null
    open_service_mesh_enabled         = "false"
    private_cluster_enabled           = "true"
    private_dns_zone_id               = module.private_dns_aks_customdns_vnet.id
    private_cluster_public_fqdn_enabled = "false"

    identity {
        type = "SystemAssigned"
    }

    network_profile {
        network_plugin     = "kubenet"
        load_balancer_sku  = "standard"
        dns_service_ip     = "10.96.1.10"
        #docker_bridge_cidr = "172.17.0.1/16"
        service_cidr       = "10.96.0.0/12"
        pod_cidr           = "10.244.0.0/16"
        outbound_type      = "userDefinedRouting"
    }

    tags = { Environment = "Dev"}

    dynamic "maintenance_window" {
        for_each = length([]) == 0 && length([]) == 0 ? [] : [""]
        content {
        dynamic "allowed" {
            for_each = []
            content {
            day   = allowed.value["day"]
            hours = allowed.value["hours"]
            }
        }

        dynamic "not_allowed" {
            for_each = []
            content {
            start = not_allowed.value["start"]
            end   = not_allowed.value["end"]
            }
        }
        }
    }

    default_node_pool {
        temporary_name_for_rotation = "demand"
        name                 = "devhubnode"
        vm_size              = "Standard_D4s_v5"
        node_count           = 1
        enable_auto_scaling  = "true"
        min_count            = 1
        max_count            = 3
        node_labels          = {app = "dev-common-workloads"}
        max_pods             = 30
        os_disk_size_gb      = "128"
        os_disk_type         = "Managed"
        ultra_ssd_enabled    = "true"
        vnet_subnet_id       = module.azure_virtual_network.subnets_map[local.Subnet_AKS]
        type                 = "VirtualMachineScaleSets"
        zones                = ["1","2","3"]
        orchestrator_version = "1.28.9"
        tags                 = { Environment = "Dev"}
        #dynamic "upgrade_settings" {
        #    for_each = []
        #    content {
        #        max_surge = var.upgrade_settings.max_surge
        #    }
        #}
    }

    auto_scaler_profile {
        balance_similar_node_groups      = var.aks_auto_scaler_profile.balance_similar_node_groups
        max_graceful_termination_sec     = var.aks_auto_scaler_profile.max_graceful_termination_sec
        new_pod_scale_up_delay           = var.aks_auto_scaler_profile.new_pod_scale_up_delay
        scale_down_delay_after_add       = var.aks_auto_scaler_profile.scale_down_delay_after_add
        scale_down_delay_after_delete    = var.aks_auto_scaler_profile.scale_down_delay_after_delete
        scale_down_delay_after_failure   = var.aks_auto_scaler_profile.scale_down_delay_after_failure
        scan_interval                    = var.aks_auto_scaler_profile.scan_interval
        scale_down_unneeded              = var.aks_auto_scaler_profile.scale_down_unneeded
        scale_down_unready               = var.aks_auto_scaler_profile.scale_down_unready
        scale_down_utilization_threshold = var.aks_auto_scaler_profile.scale_down_utilization_threshold
        skip_nodes_with_local_storage    = var.aks_auto_scaler_profile.skip_nodes_with_local_storage
        skip_nodes_with_system_pods      = var.aks_auto_scaler_profile.skip_nodes_with_system_pods
    }

}