# CHANGELOG

## 1.0.0

## Feature

- Added SECURITY.md, SUPPORT.md, THIRD_PARTY_NOTICES.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md for compliance and governance purposes.
- Added use cases in `examples_use_cases` folder based on real-life scenarios.
- (BREAKING) Moved templates to steps folder to leave place for expansion for other kinds of templates (ex: jobs, stage)
- Added Bicep deployment support
- Added Bicep module integration/initialization to artifact function
- Added PSRule Assessment function
- Modified Pre-commit function to integrate login/logout of docker registry containing pre-commit image.
- Add definition to build and push a Docker image to an Azure Container Registry.
- Add definition for Terraform deployment.
- Add definition for code quality evaluation via super-linter (beta) and pre-commit.
- Add definition for build artifact creation.
- Add beta definition for Teams notification.

## Maintenance

- Cleanup static references for tests.
