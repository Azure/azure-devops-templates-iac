@description('Tags to apply to the resource group.')
param resourceGroupTags object = { test: 'test' }

@description('Service principal app registration id of the SP deploying the resources.')
param servicePrincipalId string = 'UID'

@description('Name of the storage account to deploy.')
param storageAccountName string = 'test'

@description('Configurations of the blob containers to deploy.')
param storageAccountBlobContainers array = [{ name: 'test', publicAccess: 'None'}]

@description('SKU of the storage account to deploy')
param storageAccountSKU string = 'StorageV2'

@description('Kind of the storage account to deploy')
param storageAccountKind string = 'Standard_LRS'

@description('Configurations of the blob containers to deploy.')
param storageAccountTags object = { test: 'test' }

@description('Configurations of the subnet and virtual network where the storage account private endpoints will reside in.')
param virtualNetworkPrivateEndpointSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, virtualNetworkName: 'test', subnetName: 'test'}

@description('Name of the key vault to create')
param keyVaultName string = 'test'

@description('Tags to apply to key vault related resources')
param keyVaultTags object = { test: 'test' }

@description('Configuration for diagnostic settings')
param diagnosticsSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, logAnalyticsWorkspaceName: 'test', storageAccountName: 'test', eventHubNamespaceName: 'test', eventHubNamespaceAuthorizationRuleName: 'RootManageSharedAccessKey'}

var backboneResourceGroupName = resourceGroup().name
var backboneResourceGroupLocation = resourceGroup().location
var backbonePrivateEndpointSubnetId = '${resourceId(virtualNetworkPrivateEndpointSettings.subscriptionId, virtualNetworkPrivateEndpointSettings.resourceGroupName, 'Microsoft.Network/virtualNetworks', virtualNetworkPrivateEndpointSettings.virtualNetworkName)}/subnets/${virtualNetworkPrivateEndpointSettings.subnetName}'

var diagnosticsWorkspaceId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.OperationalInsights/workspaces', diagnosticsSettings.logAnalyticsWorkspaceName)
var diagnosticsStorageAccountId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.Storage/storageAccounts', diagnosticsSettings.storageAccountName)
var diagnosticsEventHubAuthorizationRuleId = '${resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.EventHub/namespaces', diagnosticsSettings.eventHubNamespaceName)}/authorizationrules/${diagnosticsSettings.eventHubNamespaceAuthorizationRuleName}'

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(backboneResourceGroupName)
  params: {
    onlyUpdate: bool('true')
    tags: resourceGroupTags
  }
}

module storageAccountModule './modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: 'deploy-sa-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(backboneResourceGroupName)
  params: {
    name: storageAccountName
    location: backboneResourceGroupLocation
    lock: ''
    allowBlobPublicAccess: false
    blobServices: {
      deleteRetentionPolicy: true
      deleteRetentionPolicyDays: 7
      containers: storageAccountBlobContainers
    }
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: backbonePrivateEndpointSubnetId
        tags: storageAccountTags
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      iprules: [
        {
          action: 'Allow'
          value: '1.1.1.1'
        }
      ]
      virtualNetworkRules: []
    }
    storageAccountKind: storageAccountKind
    storageAccountSku: storageAccountSKU
    supportsHttpsTrafficOnly: true
    tags: storageAccountTags
    diagnosticWorkspaceId: diagnosticsWorkspaceId
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
  }
}

module keyVaultModule './modules/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'deploy-kv-${uniqueString(resourceGroup().name)}'
  params: {
    name: keyVaultName
    location: backboneResourceGroupLocation
    lock: ''
    createMode: 'default'
    vaultSku: 'standard'
    enableRbacAuthorization: true
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Key Vault Administrator'
        description: 'Key Vault Administrator Role Assignment'
        principalIds: [
            servicePrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    enableSoftDelete: false
    enablePurgeProtection: false
    softDeleteRetentionInDays: 7
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    privateEndpoints:  [
      {
        subnetResourceId: backbonePrivateEndpointSubnetId
        service: 'vault'
        tags: keyVaultTags
      }
    ]
    tags: keyVaultTags
    secrets: {
      secureList: [
        {
          attributesExp: 1702648632
          attributesNbf: 10000
          contentType: 'string'
          name: 'vmAdminPassword'
          value: 'Ch@Ng3M3!123'
        }
      ]
    }
    keys: []
    diagnosticWorkspaceId: diagnosticsWorkspaceId
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
  }
}

@description('Name of the network resource group in which the resources are deployed.')
output backboneResourceGroupName string = backboneResourceGroupName

@description('Location of the network resource group.')
output backboneResourceGroupLocation	string = backboneResourceGroupLocation

@description('Name of the deployed storage account.')
output storageAccountName string = storageAccountModule.outputs.name

@description('ResourceID of the deployed storage account.')
output storageAccountResourceId string = storageAccountModule.outputs.resourceId

@description('Blob endpoint of the deployed storage account.')
output storageAccountblobEndpoint string = storageAccountModule.outputs.primaryBlobEndpoint

@description('Name of the deployed key vault.')
output keyVaultName	string = keyVaultModule.outputs.name

@description('ResourceID of the deployed key vault.')
output keyVaultResourceId	string = keyVaultModule.outputs.resourceId

@description('URI of the deployed key vault.')
output keyVaultURI string =  keyVaultModule.outputs.uri
