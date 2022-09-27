# CHANGELOG

## 0.3.0

### Feature

Hook updates

- pre-commit-terraform = 1.74.2
- check-azure-bicep = 0.4.0
- gitleaks = 8.12

Component updates

- TERRAFORM = 1.3.0
- TFLINT = v0.40.1
- TFLINT_AZURERM = 0.18.0
- TFSEC = 1.28.0

## 0.1.2

### Feature

- Disabled check-azure-bicep, it is too unstable to use it here yet. Active deployment from maintainer.

Hook updates

- pre-commit-terraform = 1.74.2
- check-azure-bicep = 0.4.0
- gitleaks = 8.12

Component updates

- PYTHON_IMAGE = 3.10.6-alpine3.16
- PRE_COMMIT = 2.20.0
- TERRAFORM = 1.2.8
- TFLINT = v0.39.3
- TFSEC = 1.27.6
- TFUPDATE = 0.6.7
- INFRACOST = v0.10.11

## 0.1.1

### Feature

- None

### Fix

- Fixed reference to create artifact definition file.

## 0.1.0

### Feature

- Set some pipeline variables as parameters instead.
- Updated README.md.
- Bumped version of reference to ado-yaml-pipelines-base.

## 0.0.1

- Initial container creation.
- Saved with builder container 200MB from single docker container creation.
- Create base documentation in README.md.
- Set license to MIT.
