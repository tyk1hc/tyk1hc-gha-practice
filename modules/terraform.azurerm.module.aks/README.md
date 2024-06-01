# Azure Kubernetes Service Terraform Module

This module allows to deploy a managed Kubernetes Cluster on Azure via the [Azure Kubernetes Service](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes).

It also aims to comply with Bosch Azure Implementation Guide and implements security best practices.

## Overview

The module will provision an AKS-Cluster with multiple features. According to MSA-AKS the Azure Active Directory will be integrated. A Log Analytics Workspace can be passed to the module to recieve logs from the Kubernetes cluster and the Container Insights.

### Accessing Key Vault secrets inside AKS

It's possible to synchronize secrets from a key vault into volumes.

If you're using Kubernetes 1.16 or higher you can use the [Azure Key Vault Provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure) to sync Key Vault secrets into CSI volumes.

If your Kubernetes version is to low, you can use the [Key Vault FlexVolume project](https://github.com/Azure/kubernetes-keyvault-flexvol).

Both projects support using service principals for authentication against Azure.
You can use the `kvcreds` variable, which automatically:

- creates a new service principal
- stores the secret and clientId of the SP in every Kubernetes namespace you define
- assigns required permissions for the Key Vault you want to access

You only need to deploy their respective drivers.

Both projects require you to run daemonsets as root, which violates MSA-AKS-01.09.
This is why this option is disabled by default, but can be used via the variable `kvcreds`.
We take no responsibility for its usage.

## Contract

The module user must provide:

- A name, resource group and location that serves as basis for all resource names in this module.
- A Kubernetes version which is supported by Azure.
- Log Analytics Workspace.
- A subnet for the AKS.
- Optional: Service principal (SP) for the AKS-Cluster.
- Optional: Keyvault with secrets, which can be synched into flexvolumes (requires permissions to create and manage service principals).
- Optional: List of AAD Group Object IDs ([Azure Docs](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal)).

### Service principal or managed identity

The module lets you choose between using a service principal or a managed identity for the cluster.

In case you want to use a SP, it must be created beforehand and needs to have the Contributor role.

If you don't provide the ID and secret for the SP the module will automatically use a managed identity.
Because the identity is newly created some role assignments are necessary. This requires you to run Terraform with Owner permissions.

It's recommended to use managed identity if you have Owner permissions, because you don't need to take care of the secrets management for the managed identity.

## Module Usage

Replace <desired-version> with the current module version:

```
source = "git::https://dev.azure.com/bosch/InfrastructureAsCode/_git/terraform.azurerm.module.aks?ref=<desired-version>"
```

An example can be found in the [example folder](https://dev.azure.com/bosch/InfrastructureAsCode/_git/terraform.azurerm.module.aks?path=%2Fexample)

### Access to Kubernetes API Server
 
The kubernetes API Server is the central component to perform actions like creation of resources or scaling of the nodes. 
To improve security for aks clusters access to this component has to be restricted. 
The module allows access to the kubernetes API server only from Bosch proxy IP addresses, with the `api_server_authorized_ip_ranges` parameter by default.
Changing it to `[]` will open the kubernetes API server to the whole internet and all authorized users are able to call kubectl commands against it.

Further information can be found at the [Microsoft Azure documentation](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges)

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/).
You can find each release in the git tags.

During initial development, the major version will be 0 (e.g., `0.x.y`), which
indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will
make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.

## How is this Module tested?

Tests are written in Kotlin and are based on JUnit 5 as runner. A test execution consists of three phases:

1. terraform apply (in a @BeforeClass method)
2. Run all tests and assertions (As @Test methods)
3. terraform destroy (in a @AfterClass method)

Errors in any of the three phases lead to failing tests, as it should be.

Apply is usually run inside the fixture dir, which contains the code for a regular module usage, like so:

```terraform
module "my-module" {
  source = "../.."
  name   = var.name
  paramX = var.paramX
  # ...
}
```

Everything that is a variable in the fixture, must be set from the test code.
For that, the tfApply() and tfDestroy() methods take a Map<String, String> that
contains the variable mappings.

Usually there is at least a variable called "name" that is used throughout the
fixture, so that resources from different test exections have different names.
The test commons library provides a nonce() method for this.

Tests should cover functionality of this module. Functionality of used
(sub)modules should be tested in their codebase, not here.

### Running the tests with Gradle

First, set and export the four variables with your service principal’s details:

```bash
export ARM_CLIENT_ID=...
export ARM_CLIENT_SECRET=...
export ARM_TENANT_ID=...
export ARM_SUBSCRIPTION_ID=...
```

Then tests can be run with gradle inside the test dir: `./gradlew clean test`

## Using Kubernetes Provider together with this module

This modules exposes all parameters necessary for the configuration of the kubernetes: host, client_certificate, client_key and ca_certificate.

You can configure your Kubernetes Provider like following:

```
provider "kubernetes" {
  version = "2.0.3"

  host                   = module.aks.kube_admin_config_host
  client_certificate     = module.aks.kube_admin_config_client_certificate
  client_key             = module.aks.kube_admin_config_client_key
  cluster_ca_certificate = module.aks.kube_admin_config_cluster_ca_certificate
}
```
## Open Service Mesh

Microsoft drives the [Open Service Mesh](https://openservicemesh.io/).
There is a variable to enable the [addon](https://docs.microsoft.com/en-gb/azure/aks/open-service-mesh-about).
Still manual effort is required to configure it, as terraform does not provide further configuration beside the enable flag.