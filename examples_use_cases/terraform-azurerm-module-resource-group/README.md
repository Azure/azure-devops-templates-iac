# terraform-azurerm-module-resource-group

## Introduction

Terraform module used to deploy a resource group.

## Build and Test

Integration tests are done periodically. The process deploys all scenarios in the examples folder.

## Module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.2.7  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm)       | >= 2.41.0 |

### Providers

| Name                                                         | Version |
| ------------------------------------------------------------ | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | 3.23.0  |

### Modules

No modules.

### Resources

| Name                                                                                                                          | Type     |
| ----------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

### Inputs

| Name                                                      | Description                                                                            | Type          | Default | Required |
| --------------------------------------------------------- | -------------------------------------------------------------------------------------- | ------------- | ------- | :------: |
| <a name="input_enabled"></a> [enabled](#input_enabled)    | (Optional) Define if the use of the module is enabled or not. Great for test purposes. | `bool`        | `true`  |    no    |
| <a name="input_location"></a> [location](#input_location) | (Required) Region where the resource group will be deployed on.                        | `string`      | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)             | (Required) Name of the resource group to deploy.                                       | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)             | (Optional) Tags to be assigned to the Resource Group.                                  | `map(string)` | `{}`    |    no    |

### Outputs

| Name                                                        | Description                        |
| ----------------------------------------------------------- | ---------------------------------- |
| <a name="output_id"></a> [id](#output_id)                   | Resource ID of the resource group. |
| <a name="output_location"></a> [location](#output_location) | Location of the resource group.    |
| <a name="output_name"></a> [name](#output_name)             | Name of the resource group.        |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contribute

Don't hesitate to create fork and/or branches and contribute to the library!
This repository follows the [ReleaseFlow](https://releaseflow.org/) branching methodology.

## Versioning

This repository follows the [SemanticVersioning 2.0.0](https://semver.org/) versionning methodology.

## Changelog

The changelog is available in the [CHANGELOG.md](./CHANGELOG.md) file.

## License

The code under this repository is available under the MIT license. For more details, please refer yourself to the [license](./LICENSE) file.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
