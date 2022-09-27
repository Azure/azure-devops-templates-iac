# CHANGELOG

## 1.0.0

**_Release Candidate for public release_**

## Feature

- Added SECURITY.md, SUPPORT.md, THIRD_PARTY_NOTICES.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md for compliance and governance purposes.
- Added use cases in `examples_use_cases` folder based on real-life scenarios.
- (BREAKING) Moved templates to steps folder to leave place for expansion for other kinds of templates (ex: jobs, stage)

## Maintenance

- Cleanup static references for tests.

## 0.2.0

**_Internal only_**

## Feature

- Added Bicep deployment support
- Added Bicep module integration/initialization to artifact function
- Added PSRule Assessment function
- Modified Pre-commit function to integrate login/logout of docker registry containing pre-commit image.

## 0.1.0

**_Internal only_**

### Feature

- Add yaml definition file to build and push a Docker image to an Azure Container Registry.
- Add yaml definition file for Terraform deployment.
- Add yaml definition file for code quality evaluation via super-linter (beta) and pre-commit.
- Add yaml definition file for build artifact creation.
- Add beta yaml definition file for Teams notification.

## 0.0.1

**_Internal only_**

- Temporary build
