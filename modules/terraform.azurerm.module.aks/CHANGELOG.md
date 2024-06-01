# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [17.3.0] - 2023-02-01
### Added
- added two attributes for the autoscaler profile

## [17.2.0] - 2023-02-01
### Added
- Support for kubelet attributes

## [17.1.2] - 2023-01-12
### Added
- Make cluster suffix optional 

## [17.1.1] - 2022-11-22
### Added
- Support for usage specific sysctl settings in custom node pools
- Support for linux_os_config settings

## [17.0.1] - 2022-11-17
### Fixed
- put require terraform version in the right file

## [17.0.0] - 2022-11-09
### Breaking change
### Added
- Require Terraform version >=1.3.0  (breaking change)
- outbound_ports_allocated and idle_timeout_in_minutes for load_balancer_profile can now be configured (non-breaking change)

## [16.0.0] - 2022-08-18
### Breaking change
### Added
- Made compatible with _Terraform_ provider AzureRM version 3.x
- Made compatible with _terraform_ core version > 1.2.0
- test.yaml updated to run terraformVersion: "1.2.6"
- Added variables azure_policy_enabled and role_based_access_control_enabled
- Removed variable kube_dashboard_enabled
- AKSTEstWithoutMds.kt fix PathNotFoundException -> com.jayway.jsonpath.PathNotFoundException: Missing property in path $['properties']['addonProfiles']['omsagent'] at app//terraform.azurerm.module.aks.test.AKSTestWithoutMds.Verify that monitoring is deactivated(AKSTestWithoutMds.kt:38)


### Changed
- Removed/Replaced deprecated resource blocks.
 
## [15.0.0]
### Added
- Add node_disk_type to kubernetes cluster node pool
- Breaking change: Add node_disk_type and node_disk_size to additional node pools


## [14.1.0]
### Added
- Add node_disk_type to kubernetes cluster node pool
- Add node_disk_type and node_disk_size to additional node pools

## [14.0.0]
### Added
- Variable to enable Open Service Mesh.
- Changed azurerm provider version to ~>2.82

## [13.6.0]
### Added
- Output of cluster control plane id.

## [13.5.1]
### Fixed
- No LogAnalyticsSolution with name "container_insights" will be deployed if OSM agent is disabled in AKS.

## [13.5.0]
### Added

- Support Application Gateway Ingress Controller (AGIC)
  - AGIC is not enabled by default. To enable it add the ingress_application_gateway configuration
  - Be aware of the AGIC limitations during rolling updates, only enable if it fits your workload type
  - See: https://github.com/Azure/application-gateway-kubernetes-ingress/issues/1124


## [13.4.0]
### Added

- Support autoscaling for the default node pool
  - The autoscaler is not enabled by default. To enable autoscaling set enable_auto_scaling to true
  - The autoscaling requires you to set the variables min_count and max_count. The node_count should be set to null


### Changed

- Added new variable node_labels to define Kubernetes labels for the nodes in the default node pool

## [13.3.1]

### Fixed

- Added new log categories `csi-azuredisk-controller`, `csi-azurefile-controller` and `csi-snapshot-controller`
  - Those logs are disabled

## [13.3.0]

### Added

- Added Kubernetes cluster name to output values

## [13.2.0]

### Changed

- Changed rotation time for the CSI Service Principal password from **730** to **548** days
  - Because the password itself is only valid for 2 years (730 days) the rotation would be too late

## [13.1.0]

### Added
- Added the `upgrade_settings` dynamic block to be used for setting the `max_surge` (the maximum number or percentage of nodes which will be added to the Node Pool size during an upgrade).


## [13.0.0]

### Breaking change
- Added **node_taints** as a variable to additional pools
  - This will require you to add an empty list to continue functioning as before if you are
using the `additional_node_pools` variable.

## [12.1.1]

### Changed

- Switched from deprecated `azurerm_policy_assignment` to new `azurerm_resource_policy_assignment`
  - This change can lead to race conditions in the terraform apply and might require a rerun

## [12.1.0]
- The maximal number of pods per agent pool is now configurable (**max_pods**)

## [12.0.0]

### Breaking change

- Raised minimum supported version of Azurerm provider to 2.71.0
  - This may require you to update your provider configuration

### Added

- Added new optional parameter `automatic_channel_upgrade` to configure an upgrade channel for your AKS cluster
  - Defaults to **null**
  - Possible values are *patch*, *rapid*, *node-image* and *stable*
  - Azure documentation: https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel
- Added new parameters to configure maintenance windows for the AKS cluster
  - Azure docs: https://docs.microsoft.com/en-us/azure/aks/planned-maintenance
  - This feature is currently still in preview
  - Use the new parameter `maintenance_windows_allowed` to configure maintenance timeslots
  - Use the new parameter `maintenance_windows_not_allowed` to configure time spans, when no maintenance should be possible

### Changed

- Parameter `kubernetes_version` is optional now
  - If not specified the latest recommended version will be used at provisioning time

## [11.0.1]

### Fixed

- Added missing log category `cloud-controller-manager` for AKS diagnostic settings
  - Those logs are disabled

## [11.0.0]
- Updated to azuread provider version 2.x [(migration guide)](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/microsoft-graph)
- State migrations are a bit tricky for at least data objects.
  If problems occur removing the old resources from state and importing via new provider helps, [e.g. group_membership_claims](https://github.com/hashicorp/terraform-provider-azuread/issues/541).
- Removed [Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest)
- Added [Time Provider](https://registry.terraform.io/providers/hashicorp/time/latest)
- Rotate kv service principal credentials after 730 days (before it was invalid after 730 days).

## [10.3.0]
- Added support for user defined outbound routing (**outbound_type**)

## [10.2.0]
- Added managed identities objectId to output (**user_assigned_managed_identity_object_id**)

## [10.1.0]
- Added support for setting worker nodes resource group name (**node_resource_group**)

## [10.0.0]
### Breaking
- possibility to add whitelist for kubernetes master nodes
  - Introduced new variable `api_server_authorized_ip_ranges`
  - Limited access to aks master nodes is defaulted to bosch proxies
  - Adapt if you need access from other ips (e.g. for CI/CD)
  - set to empty list if you want the behaviour before

## [9.4.1]
- Added tags to the virtual machine scale set (VMSS) of the default agent pool

## [9.4.0]
- Added support for 2.x versions of the Kubernetes Provider

## [9.3.0]

### Changed

- Adapted `azuread` provider version constraint to support 1.x releases

## [9.2.1]
### Fixed
- Fixed [bug](https://dev.azure.com/bosch/InfrastructureAsCode/_workitems/edit/43954/) by adding a variable (aks_mds_enabled) to disable or enable AKS Monitoring diagnostic settings (enabled by default)

## [9.2.0]

### Added
-  Possibility to create additional node pools
   - Introduced new variable `additional_node_pools`
   - Autoscaling can be activated for this node_pools
   - the additional node_pools are "User" pools
   - kubernetes labels can be applied to nodes in these new pools
- Added autoscaler profile
    - can be configured via `auto_scaler_profile`
    - does not affect the default node pool
    - only applies to additional node pools that have autoscaling enabled
    - currently only one profile for all pools is supported

## [9.1.1]

### Fixed

- Added missing `azurerm` provider version constraint for 9.0.0 release
  - Now requires at least 2.33.0

## [9.1.0]

### Added
- Added variable to disable kubeaudit logs (default is enabled).

## [9.0.0]

### Breaking Changes

- `aks_network` now requires a network policy
  - Sets up network policy to be used with Azure CNI.
  - Network policy allows us to control the traffic flow between pods.
  - Currently supported values are `"calico"`, `"azure"` and `null`.
  - Changing this forces a new resource to be created.

### Added
- Added `cluster_suffix` variable
    - Defaults to `aks`
    - Allows setting the cluster suffix. The cluster name is `<name>-<cluster_suffix>` e.g. `bosch-aks` for `name: bosch` and `cluster_suffix: aks`
- Added attribute `network_policy` to the `aks_network`
- Added `managed_azuread` variable to choose if Azure AD integration should be enabled
    - Defaults to `true`
    - Is needed to fulfill organizational compliance measures and should only be set to `false` for initial integration
    - Disables `azuread_group_ids` if set to `false`
- Added variable `policy_sets` to set Azure Policies
    - Defaults to `{}`
- Added `use_managed_identity` variable to set usage of MSI or service principal explicitely
    - If set to `null` the use of MSI or service principal is decided based on `aks_sp_id` and `aks_sp_secret`
    - If set to `true` an MSI is used no matter what other variables are given
    - If set to `false` a service principal is used no matter what other variables are given. **Attention:** In this case `aks_sp_id` and `aks_sp_secret` are required
    - Variable should only be used explicitly if using the automatic setup leads to terraform plan issues like this one:
- Added `node_resource_group` output
    - Returns the name of the auto-generated resource group that hosts the AKS nodes
- Added `kubernetes_cluster_fqdn` output
    - Returns the FQDN of the AKS terraform resource

## [8.1.0]

### Added

- AKS metric categories will be fetched dynamically now

## [8.0.1]

### Fixed

- Added missing metrics category `API Server (PREVIEW)` for AKS diagnostic settings

## [8.0.0]

### Breaking Change

- Module now requires Terraform 0.13.x or higher
  - Terraform 0.12.x is no longer supported

## [7.1.1]

### Fixed

- Applied `kubernetes_version` to default node pool as well

## [7.1.0]

### Added

- Added `kube_dashboard_enabled` variable to choose if the kube dashboard addon should be installed
  - Defaults to `true`
  - For AKS 1.19 and higher the addon isn't supported and should be disabled

## [7.0.0]

### Breaking Changes

- Raised minimum supported version of Azurerm provider to 2.21.0
  - This requires you to update your provider configuration
- Removed support for **AvailabilitySet** as the node pool type
  - The azurerm provider has a bug affecting clusters with an AvailabilitySet node pool
  - It's not possible to do any changes to the cluster after its creation
  - This bug exists at least since version 1.42 of the azurem provider
  - The issue gets tracked on [GitHub](https://github.com/terraform-providers/terraform-provider-azurerm/issues/5551)
- Replaced legacy AAD intregration with the new managed one
  - It's no longer nessecary to create a Server and Client application
  - For migration remove those parameters from the module call
  - Azure will automatically update your cluster to the new integration without downtime or recreation
  - During the migration you can't access the Kubernetes API with your user credentials
  - Afterwards you need to fetch new user credentials

### Added

- Added variable `sku_tier` to support **Paid** tier for AKS
  - Defaults to `Free`
  - **Paid** tier includes the [Uptime SLA](https://docs.microsoft.com/en-us/azure/aks/uptime-sla)

### Removed

- Removed variable `node_pool_type`
- Removed variables `aad_server_id`, `aad_server_secret` and `aad_client_id`

## [6.2.2]

### Fixed

- Applying the module won't try to change `guard` logs anymore

## [6.2.1]

### Fixed

- Applying the module won't try to change `kube-audit-admin` logs anymore

## [6.2.0]

### Added
- an optional `load_balancer_profile` variable can be set which can specify an existing public
  IP address for the outgoing traffic of the K8s cluster

## [6.1.0]

### Added
- add a variable to optional disable the OSM agent

## [6.0.1]

### Fixed

- Set kube-dashboard explicitly to avoid changes on every apply

## [6.0.0]

### Breaking Changes

- removed deployment of Key Vault FlexVolume daemonset, when using `kvcreds`
  - the [project](https://github.com/Azure/kubernetes-keyvault-flexvol) is deprecated
  - follow these [steps](https://github.com/Azure/kubernetes-keyvault-flexvol#option-2-existing-aks-cluster) to achieve the same behaviour as before
  - for AKS 1.16 and higher you can use the new [csi-secret-provider](https://github.com/Azure/secrets-store-csi-driver-provider-azure) for Azure instead

### Added

- Using `kvcreds` supports the [Azure Provider](https://github.com/Azure/secrets-store-csi-driver-provider-azure) for the [Secrets Store CSI Driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver) now
  - it will create a SP and necessary permissions for you

### Removed

- removed deployment of Key Vault FlexVolume daemonset, when using `kvcreds`

## [5.0.0] - 2020-05-06

### Breaking Changes

- Raised minimum supported version of Azurerm provider to 2.6.0
  - This requires you to update your provider configuration
- Raised key vault flexvolume project version to 0.0.17

### Added

- added support for managed identity
  - this requires Owner permissions
  - it's still possible to pass in a service principal
- new variable `acr_id` to create connection to ACR
- added output `user_assigned_managed_identity_client_id`

### Changed

- variables `aks_sp` and `aks_sp_secret` are now optional

## [4.0.0] - 2020-03-27

### Breaking Changes

- Raised minimum supported version of Azurerm provider to 2.0.0
  - This requires you to update your provider configuration
- Changed default for AKS load balancer SKU from `basic` to `standard`
  - This can be changed via the `load_balancer_sku` variable
  - The Azurerm provider and Azure use the same default value

### Changed

- Raised minimum supported version of Azurerm provider to 2.0.0
- Changed default for AKS load balancer SKU from `basic` to `standard`

## [3.0.1] - 2020-03-26

### Fixed

- Ignore changes to attribute `windows_profile` in AKS to avoid recreation
  - See this [GitHub issue](https://github.com/terraform-providers/terraform-provider-azurerm/issues/6235) for more information

## [3.0.0] - 2019-12-18
### Breaking Changes
- Raised minimal required version of the azurerm provider to 1.37
- Changed the default type of the node pool to `VirtualMachineScaleSets`
  - Use the new `node_pool_type` variable to change the node pool type
  - If you want to migrate to this release without having to recreate your cluster, use `AvailablitySet` as the node pool type

### Added
- Added variables:
  - `node_pool_type` to configure type of the default node pool
  - `load_balancer_sku` to configure the sku of the load balancer in the AKS cluster
  - `availability_zones` to distribute node accross availability zones
- Expose the Kubernetes cluster ID to support multiple node pools
  - See node-pool.tf in the example on how to do add node pools to the cluster

## [2.2.0] - 2019-12-16
### Changed
- Set newest allowed `azurerm` version to 1.36
  - The next major release will support 1.37 and higher
  - This change is caused by a breaking change in the 1.37 release (see https://github.com/terraform-providers/terraform-provider-azurerm/releases/tag/v1.37.0)

## [2.1.0] - 2019-11-26
### Added
- Save `kube-audit` logs to Log Analytics workspace

## [2.0.0] - 2019-11-18
### Breaking Changes
- Changed minimal required version of terraform from 0.12 to 0.12.9 (see bug fixes)
### Bug fixes
- Default value of kvcreds doesn't lead to error anymore with terraform 0.12.7 (fix requires 0.12.9)

## [1.0.0] - 2019-10-22
### Added
- Azure Kubernetes Service (AKS) featuring:
  - AAD Integration
  - Keyvault Integration over flexvolume
  - Container Insights
- Updated license to BIOSL v4 -- Bosch Internal Open Source License Version 4
- Azure Implementation Guide (IMG) compliance table
- Azure Build Pipeline to run tests

### Changed

### Removed
