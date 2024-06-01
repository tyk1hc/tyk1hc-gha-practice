# Azure Storage Account

This repo contains a module to deploy a [Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview) on 
[Azure](https://azure.microsoft.com/) using [Terraform](https://www.terraform.io/).

## Quickstart

- Open command line in the desired module directory

- For Azure auth there are several ways:

  * Use your own Azure Account to login:

    Run `az login`, put the code in the browser, choose your user then and return to the cli to get a valid session.
    
    Then run `az account set -s REPLACE_ME_subscription_name` to set the default subscription to the desired one.

  * Use a service principal to login directly to a target subscription:

    Run `az login --service-principal -u REPLACE_ME_service_principal_name -p REPLACE_ME_service_principal_password --tenant REPLACE_ME_tenant_id`

- Run `terraform init` This will create a .terraform folder and download any required plugins (azure provider in this case)

- Run `terraform validate` This will validate the terraform files

- Run `terraform plan` This will show the changes terraform wants to perform

- Run `terraform apply` This will create the resource in Azure and also the terraform.tfstate local state backend file.

- Run `terraform destroy` This will delete the resource in Azure


## Module Usage

Use as module source the following and replace <desired-version> with the current module version: 

```
 source   = "git::https://dev.azure.com/bosch/Terraform for Bosch/_git/terraform.azurerm.module.storage-account?ref=<desired-version>"
```
An example [is in the example folder](https://dev.azure.com/bosch/Terraform%20for%20Bosch/_git/terraform.azurerm.module.storage-account?path=%2Fexample&version=GBmaster)

There are some default tags that will be applied:
* creator "terraform"
* module_name "storage_account"
* module_version as set in [main.tf](https://bosch.visualstudio.com/Terraform%20for%20Bosch/_git/terraform.azurerm.module.storage-account?path=%2Fmain.tf&version=GBmaster)
* subscription (subscription which was used when running the apply)
* terraform_workspace (terraform workspace which was used during the apply)

## Variables

See [variables.tf](https://bosch.visualstudio.com/Terraform%20for%20Bosch/_git/terraform.azurerm.module.storage-account?path=%2Fvariables.tf&version=GBmaster)
for required and optional parameters.

## Output

See [outputs.tf](https://bosch.visualstudio.com/Terraform%20for%20Bosch/_git/terraform.azurerm.module.storage-account?path=%2Foutputs.tf&version=GBmaster)

## What's a module?

A module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure such 
as a database or server cluster. Each module is created primarily using [Terraform](https://www.terraform.io/), 
includes automated tests, examples, documentation and is maintained by infrastructure as code (IaC) enthusiasts at Bosch.
Making the source code open source is a nice idea that needs to be pursued more. 

Instead of having to figure out the details of how to run a piece of infrastructure from scratch you can reuse 
existing code that has been proven in production. Furthermore you don't have to maintain the module by yourself because 
this work is done by the community and the module maintainers. 

Each module has the following folder structure:

* [root]: The root folder contains the definition of the reusable module.
* [examples]: This folder contains examples of how to use the module.
* [test]: This folder contains integration tests for the module.


## How do I contribute to this module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://inside-docupedia.bosch.com/confluence/display/Terraform/Contributing).

## How is this module versioned?

Read more about the [versioning](https://inside-docupedia.bosch.com/confluence/display/Terraform/Module+Layout).
You can find the current version in the RELEASE file.

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, 
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