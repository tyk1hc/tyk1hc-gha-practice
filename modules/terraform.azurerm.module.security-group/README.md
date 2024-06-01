# MY CLOUD SERVICE | Terraform template fullfilling | [MSA-AAG](https://inside-docupedia.bosch.com/confluence/display/Terraform/Microsoft+Azure)

This module can be used to provision an [NSG](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)

It also aims to comply with Bosch Azure Implementation Guide and implements
security best practices.

## Overview

The module will provision a Network Security Group itself within the given resource group and Log Analytics Worksapce.


### Contract

The module user must provide:

* A name for NSG instance.
* A resource group. 
* Optional: log analytics ID
* Optional: tags that you want to apply to all resources provisioned by this
  module.

So in particular, the user of this module must make sure to provision:
* A resource group
* A log analytics ID, should the diagnostic settings be logged

## Quickstart

* Make sure you have clone access (token or user credentials) to this
  repository.
* Provision the required resources yourself
* Instantiate a module as seen below:


## Module Usage

Replace <desired-version> with the current module version:
Instead of git::https://xxx you may also use git@ssh.dev.azure.com:v3/bosch/InfrastructureAsCode/terraform.azurerm.module.network-security-group, 
given that you have already registered your public key in the repo and you can provide the private key to the deployment environment.

```
module "datafactory" {
  source           = "git::https://dev.azure.co/bosch/dev.azure.com/bosch/InfrastructureAsCode/_git/terraform.azurerm.module.network-security-group?ref=<desired-version-or-branch>"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lana.id
  nsg_name = "somerandomname"
  resource_group = azurerm_resource_group.rg
  connections  = [
    { name                = "worker-to-worker",
      source_address      = "VirtualNetwork",
      source_port         = "85527",
      protocol            = "Tcp",
      destination_address = "Storage",
      access              = "Deny"
      direction           = "inbound"
    },
    { name                = "worker-to-worker-outbound",
      source_address      = "VirtualNetwork",
      destination_address = "VirtualNetwork",
      direction           = "outbound"
    },
  ]
}
```


## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution
Guidelines](https://inside-docupedia.bosch.com/confluence/display/Terraform/Contribution+Guidelines)
for instructions.


## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/).
You can find each release in the BitBucket Tags.

During initial development, the major version will be 0 (e.g., `0.x.y`), which
indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will
make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.
