# yaml-pipelines-base

## Introduction

This repository contains a library of Azure DevOps YAML pipelines reusable action definitions. This repository can be referenced in a pipeline running else where, that way, if we update the tasks, everyone can use the updated code.

## Organization

The YAML files are sorted in multiple folders according to the kind of templates they are hosting and their area of effectiveness.

The folders in the `steps` are:

- codequality: Every actions related to code QA , linting, security scan and the likes.
- docker: Every actions related to docker and managing repositories.
- terraform: Every actions related to the deployment and management of Terraform resources.
- bicep: Every actions related to the deployment and management of Bicep resources.
- tools: Every actions related to internal tools like sending a Teams notification or an email.

The folder `example_use_cases` contain different examples demonstrating how to use the resusable definitions:

- bicep-example-keyvault: Deploy a keyvault with a private endpoint using bicep on multiple environments dynamically and ensuring the quality of the code.
- docker-pre-commit: Build and upload a Docker image containing pre-commit tools.
- terraform-azurerm-module-resource-group: Run integration tests for the module we built and deploys the resources as defined on the tests.

## Build and Test

No tests are currently done on those files. It's on a todo list.

Pre-Commit is used to make sure the formatting of the files is following a standard.

## Contribute

Don't hesitate to create forks and contribute to the code!

Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for more details.

This repository follows the [ReleaseFlow](https://releaseflow.org/) branching methodology.

## Versioning

This repository follows the [SemanticVersioning 2.0.0](https://semver.org/) versionning methodology.

## Changelog

The changelog is available in the [CHANGELOG.md](./CHANGELOG.md) file.

## License

The code under this repository is available under the MIT license.
For more details, please refer yourself to the [license](./LICENSE) file.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
More details can be found in the [CODE_OF_CONDUCT](./CODE_OF_CONDUCT.md) file.

## Notice

The third party usage notice can be found in the [THIRD_PARTY_NOTICES](./THIRD_PARTY_NOTICES.md).

Thanks to the awesome people who develop awesome tools and make them available to the community!
