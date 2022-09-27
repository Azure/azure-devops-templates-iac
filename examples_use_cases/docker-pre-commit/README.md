# docker-pre-commit

## Introduction

This repository contains the automation to build and publish a docker image with pre-commit configured to parse infrastructure as code (Terraform or Bicep).

Additional hooks can be found [here](https://pre-commit.com/hooks.html).

## Organization

TBD

## Build and Test

No tests are currently done on those files. It's on a todo list.

## How to use

### PowerShell

In your Powershell profile, you need to add the following function and alias to be able to call the container from your shell. Change the registry and the image name to fit your parameters.

```pwsh
function Invoke-PreCommit {
    docker run -rm -v ${PWD}:/data -w /data #{acrName}#.azurecr.io/docker-pre-commit:main $args
}

Set-Alias -Name pre-commit -Value Invoke-PreCommit
```

Once it is set, you need to add a `.pre-commit-config.yaml` at the root of the repository you want to verify the code. You can copy the one from this repository.

Set the current directory to the repository and run `pre-commit run -a` and see the code being modified by the rules you have set with the `.pre-commit-config.yaml` file.

### Azure DevOps

The docker container can be used in a CICD pipeline. Here's a quick example showing how to call the container from Azure DevOps.

```
parameters:
  - name: workingDirectoryPath
    displayName: "(String) Path of the root directory containing the code to scan."
    type: string
    default: $(System.DefaultWorkingDirectory)
  - name: dockerPreCommitImageName
    displayName: "(String) Name of the pre-commit docker image in the registry"
    type: string
    default: "docker-pre-commit"
  - name: dockerPreCommitImageTag
    displayName: "(String) Docker image tag to use during execution."
    type: string
    default: "dev"
  - name: dockerPreCommitRegistry
    displayName: "(String) FQDN of the registry containing the pre-commit image."
    type: string
    default: "#{acrName}#.azurecr.io"
  - name: enableGitInitialization
    displayName: "(String) Text boolean defining if git init should be ran or not."
    type: string
    default: "true"
steps:
  - task: Powershell@2
    name: runPreCommit
    displayName: "Scan and validate code with Pre-Commit"
    inputs:
      pwsh: true
      workingDirectory: ${{ parameters.workingDirectoryPath }}
      targetType: inline
      script: |
        if("${{ parameters.enableGitInitialization }}" -eq "true"){
          git init
          git add -A
          git checkout -b precommiteval
        }

        docker pull ${{ parameters.dockerPreCommitRegistry }}/${{ parameters.dockerPreCommitImageName }}:${{ parameters.dockerPreCommitImageTag }}
        docker run --rm -v ${{ parameters.workingDirectoryPath }}:/data -w /data ${{ parameters.dockerPreCommitRegistry }}/${{ parameters.dockerPreCommitImageName }}:${{ parameters.dockerPreCommitImageTag }} run -a\
```

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
