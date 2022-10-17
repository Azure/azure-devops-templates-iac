@description('Tags to apply to the resource group')
param resourceGroupTags object = { test: 'test' }

@description('Name of the virtual machine to deploy.')
param virtualMachineName string = 'test'

@description('Local administrative username of the virtual machine to deploy.')
param virtualMachineLocalAdminUsername string = 'test'

@description('Tags to apply to the virtual machine resources')
param virtualMachineTags object = { test: 'test' }

@description('Name of the key vault containing the VM password')
param keyVaultName string = 'test'

@description('Name of the secret in the key vault containing the VM password')
param keyVaultSecretName string = 'test'

@description('Resource Group name of the key vault containing the VM password')
param keyVaultResourceGroupName string = 'test'

@description('Resource Group Name of the recovery service vault that will hosts the VM backups.')
param backupVaultResourceGroupName string = 'test'

@description('Name of the recovery service vault that will hosts the VM backups.')
param backupVaultName string = 'test'

@description('Name of the backup policy in the recovery service vault that will apply to the VM backups.')
param backupPolicyName string = 'VMpolicy'

@description('Configurations of the subnet and virtual network where the storage account private endpoints will reside in.')
param virtualNetworkSubnetSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, virtualNetworkName: 'test', subnetName: 'test'}

@description('Configuration for diagnostic settings')
param diagnosticsSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, logAnalyticsWorkspaceName: 'test', storageAccountName: 'test', eventHubNamespaceName: 'test', eventHubNamespaceAuthorizationRuleName: 'RootManageSharedAccessKey'}

var applicationResourceGroupName = resourceGroup().name
var applicationResourceGroupLocation = resourceGroup().location
var applicationSubnetId = '${resourceId(virtualNetworkSubnetSettings.subscriptionId, virtualNetworkSubnetSettings.resourceGroupName, 'Microsoft.Network/virtualNetworks', virtualNetworkSubnetSettings.virtualNetworkName)}/subnets/${virtualNetworkSubnetSettings.subnetName}'

var diagnosticsWorkspaceId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.OperationalInsights/workspaces', diagnosticsSettings.logAnalyticsWorkspaceName)
var diagnosticsStorageAccountId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.Storage/storageAccounts', diagnosticsSettings.storageAccountName)
var diagnosticsEventHubAuthorizationRuleId = '${resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.EventHub/namespaces', diagnosticsSettings.eventHubNamespaceName)}/authorizationrules/${diagnosticsSettings.eventHubNamespaceAuthorizationRuleName}'

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(applicationResourceGroupName)
  params: {
    onlyUpdate: bool('true')
    tags: resourceGroupTags
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup(keyVaultResourceGroupName)
}

module virtualMachineModule './modules/Microsoft.Compute/virtualMachines/deploy.bicep' = {
  name: 'deploy-vm-${uniqueString(deployment().name)}'
  scope: resourceGroup(applicationResourceGroupName)
  params: {
    name: virtualMachineName
    lock: ''
    adminUsername: virtualMachineLocalAdminUsername
    adminPassword: keyVault.getSecret(keyVaultSecretName)
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-Datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: applicationSubnetId
            enableAcceleratedNetworking: false
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v4'

    backupPolicyName: backupPolicyName
    backupVaultName: backupVaultName
    backupVaultResourceGroup: backupVaultResourceGroupName
    dataDisks: [
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '32'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      {
        caching: 'None'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '32'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    ]
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticWorkspaceId: diagnosticsWorkspaceId

    extensionMonitoringAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    monitoringWorkspaceId: diagnosticsWorkspaceId
    systemAssignedIdentity: true
    tags: virtualMachineTags
  }
}

@description('Name of the application resource group in which the resources are deployed.')
output applicationResourceGroupName string = applicationResourceGroupName

@description('Location of the application resource group.')
output applicationResourceGroupLocation	string = applicationResourceGroupLocation

@description('Name of the deployed virtual machine.')
output applicationVirtualMachineName	string = virtualMachineModule.outputs.name

@description('Location of the deployed virtual machine.')
output applicationVirtualMachineLocation	string = virtualMachineModule.outputs.location

@description('Location of the deployed virtual machine.')
output applicationVirtualMachineResourceId	string = virtualMachineModule.outputs.resourceId
