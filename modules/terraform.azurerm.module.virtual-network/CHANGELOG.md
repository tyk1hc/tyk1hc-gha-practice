# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## [5.0.0] - 2022-08-19
### Breaking change
### Added
- Made compatible with _Terraform_ provider AzureRM version 3.x
- Made compatible with _terraform_ core version > 1.2.0
- test.yaml updated to run terraformVersion: "1.2.6"

## [4.0.1] - 2021-07-16
### Changed
- private endpoint and private service link for subnets added as optional
- subnet service endpoints now optional
- subnet delegation parameters now optional 
- type for subnet variable is not enforced

## [4.0.0] - 2021-07-07
### Changed
- Breaking Change: Subnets added with a map of input variables instead of a list
- Name of monitoring diagnostics settings resource

## [3.0.0] - 2021-04-29
### Added
- 'delegation_actions' setting for subnets 
- Example and template for subnets

## [2.1.1] - 2021-03-25
### Changed
- Diagnostic settings now optional as it is not available on Azure china

## [2.1.0] - 2021-01-18
### Changed
- Diagnostic settings added 

## [2.0.0] - 2020-03-05
### Changed
- Required provider version set to 2

## [1.2.0] - 2020-02-03
### Added
- An optional ddos protection plan for the virtual network can be set

## [1.1.0] - 2019-08-29
### Added
- Type declaration for variables

## [1.0.0] - 2019-08-29
### Added
- Initial release

