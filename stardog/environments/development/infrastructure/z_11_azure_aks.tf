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

    dev_node_pools = {
        stardog = {
        node_count ="1",
        vm_size ="Standard_E8as_v5",
        availability_zones = ["1","2","3"]
        node_disk_size ="64",
        node_disk_type = "Managed",
        cluster_auto_scaling = "true",
        cluster_auto_scaling_min_count = "1",
        cluster_auto_scaling_max_count = "3",
        max_pods = "110",
        node_labels = { app: "stardog" },
        subnet_id = module.vnet.subnets_map[local.Subnet_AppGateway],
        ultra_ssd_enabled = "true"
        owner_tag={
            owner="shared"
        }
        }
    }

}