# bicep-example-complete-product-infrastructure

## Introduction

TBD
Bicep deployment of a keyvault and a virtual network in a resource group in potentially multiple environments using publicly available bicep modules.

## Build and Test

TBD
Integration tests can be done periodically with the build environment.

## Organisation by deployment groups

In this scenario, each deployment groups should be in reality in their own repository and have their own single pipeline. They were combined in this example to make it easier to reference and show as an example.

- deploymentgroups-platform-shared : Group used to deploy shared resources to Azure. It could be considered as the resources maanged by the IT team.
- deploymentgroups-platform-project : Group used to deploy the initialization of the resource groups / resources by the IT Team for a project team. The IT Team could use this to deploy resource groups and assign permissions to a service principal to those resource groups only.
- deploymentgroups-project : Group used to deploy project-linked resources by the project team.

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
