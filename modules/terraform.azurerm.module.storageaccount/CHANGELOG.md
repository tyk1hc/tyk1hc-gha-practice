# Changelog
All notable changes to this project will be documented in this file.

## [5.0.1] - 2022-08-23
### Added

- Made compatible with terraform core version >= 1.2.0
- Updated version constraint to >= 1.2.6
- test.yaml updated to run terraform Version: "1.2.6"

## [5.0.0] - 2022-04-20
### Added
- Made compatible with _Terraform_ provider AzureRM version >= 3.0.2.

### Changed
- Renamed property `allow_blob_public_access` to `allow_nested_items_to_be_public` (see [Changelog v3.0.2](https://github.com/hashicorp/terraform-provider-azurerm/blob/v3.0.2/CHANGELOG.md))

## [4.1.0] - 2022-01-05
### Added
- Added support for blob versioning

## [4.0.0] - 2021-05-31
### Added
- Integration with Log Analytics (non-destructive change for storage account, but for the diagnostics settings)

## [3.0.2] - 2021-04-06
### Changed
- Logging now adapted to work with premium storage accounts [Bug #49898](https://bosch.visualstudio.com/0c223795-4430-497f-bda5-4e87a2317a1d/_workitems/edit/49898)

## [3.0.1] - 2021-02-10
### Changed
- Module can now be used under Windows (parsing problem of local_exec command solved) 

## [3.0.0] - 2021-01-19
### Changed
- Separated loggings for storage for different services because of different schema versions
- Optional normalizing and randomizing storage name
- Advanced Threat Protection optional, because not available in Azure China
- Network Rules can now switch between allow and deny
- Minimum TLS version for storage access set to TLS v1.2
- Blob public access set explicitly to disabled

## [2.0.1] - Unreleased
### Changed
- Set log version for the log storage format in the storage account.

## [2.0.0] - 2020-05-03
### Changed
- required provider version set to 2
### Removed
- Due to the new provider the following settings and associated variables are removed
    * account_encryption_source and var.account_encryption_source; no longer supported by Azure
    * enable_file_encryption and var.enable_file_encryption; storage accounts are always encrypted by default
    * enable_blob_encryption and var.enable_blob_encryption; storage accounts are always encrypted by default
## [1.1.0] - 2019-11-07
### Added
### Changed
- Mandatory Terraform version set to >= 0.12.09 due to bugfix in Terraform v.12.9 regarding the behaviour of empty lists with for_each
### Removed

## [1.0.0] - 2019-10-31

### Added
- initial release
### Changed

### Removed