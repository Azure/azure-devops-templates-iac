@description('Tags for storage account to be used for diagnostics')
param diagnosticsResourceGroupTags object = { deploymentGroup: 'Diagnostics', tagbyIT: 'IT' }

@description('Storage account to be used for diagnostics')
param diagnosticsStorageAccountName string = 'satestdiag'

@description('Tags for storage account to be used for diagnostics')
param diagnosticsStorageAccountTags object = { deploymentGroup: 'Diagnostics', tagbyIT: 'IT' }

@description('Log analytics workspace to be used for diagnostics')
param diagnosticsLogAnalyticsWorkspaceName string = 'latestdiag'

@description('Tags for Log Analytics Workspace to be used for diagnostics')
param diagnosticsLogAnalyticsWorkspaceTags object = { deploymentGroup: 'Diagnostics', tagbyIT: 'IT' }

@description('Event Hub Namespace to be used for diagnostics')
param diagnosticsEventHubNamespaceName string = 'ehtestdiag'

@description('Event Hub Namespace authorization rule name to be used for diagnostics')
param diagnosticsEventHubNamespaceAuthorizationRuleName string = 'RootManageSharedAccessKey'

@description('Tags for Event Hub Namespace to be used for diagnostics')
param diagnosticsEventHubNamespaceTags object = { deploymentGroup: 'Diagnostics', tagbyIT: 'IT' }

var diagnosticsResourceGroupName = resourceGroup().name
var diagnosticsResourceGroupLocation = resourceGroup().location

//https://github.com/Azure/bicep/issues/1431

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(diagnosticsResourceGroupName)}'
  scope: resourceGroup(diagnosticsResourceGroupName)
  params: {
    onlyUpdate: bool('true')
    tags: diagnosticsResourceGroupTags
  }
}

module diagnosticsStorageAccountModule './modules/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: 'deploy-sa-diagnostics-${uniqueString(diagnosticsResourceGroupName)}'
  scope: resourceGroup(diagnosticsResourceGroupName)
  params: {
    name: diagnosticsStorageAccountName
    location: diagnosticsResourceGroupLocation
    lock: ''
    allowBlobPublicAccess: false
    blobServices: {
      deleteRetentionPolicy: true
      deleteRetentionPolicyDays: 7
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      iprules: []
      virtualNetworkRules: []
    }
    storageAccountKind: 'StorageV2'
    storageAccountSku: 'Standard_LRS'
    supportsHttpsTrafficOnly: true
    tags: diagnosticsStorageAccountTags
  }
}

module diagnosticsLogAnalyticsWorkspaceModule './modules/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'deploy-la-diagnostics-${uniqueString(diagnosticsResourceGroupName)}'

  scope: resourceGroup(diagnosticsResourceGroupName)
  params: {
    name: diagnosticsLogAnalyticsWorkspaceName
    location: diagnosticsResourceGroupLocation
    lock: ''
    serviceTier: 'PerGB2018'
    publicNetworkAccessForQuery: 'Enabled'
    publicNetworkAccessForIngestion: 'Enabled'
    tags: diagnosticsLogAnalyticsWorkspaceTags
  }
}

module diagnosticsEventHubNamespaceModule './modules/Microsoft.EventHub/namespaces/deploy.bicep' = {
  name: 'deploy-ehn-diagnostics-${uniqueString(diagnosticsResourceGroupName)}'
  scope: resourceGroup(diagnosticsResourceGroupName)
  params: {
    name: diagnosticsEventHubNamespaceName
    location: diagnosticsResourceGroupLocation
    lock: ''
    authorizationRules: [
      {
        name: diagnosticsEventHubNamespaceAuthorizationRuleName
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    ]
    eventHubs: [
      {
        name: diagnosticsEventHubNamespaceName
      }
    ]
    tags: diagnosticsEventHubNamespaceTags
  }
}

@description('ResourceID of the diagnostics Storage Account.')
output diagnosticsStorageAccountResourceId string = diagnosticsStorageAccountModule.outputs.resourceId

@description('ResourceID of the diagnostics Log Analytics Workspace.')
output diagnosticsLogAnalyticsWorkspaceResourceId string = diagnosticsLogAnalyticsWorkspaceModule.outputs.resourceId

@description('Workspace Customer ID of the diagnostics Log Analytics Workspace.')
output diagnosticsLogAnalyticsWorkspaceCustomerId string = diagnosticsLogAnalyticsWorkspaceModule.outputs.logAnalyticsWorkspaceId

@description('ResourceID of the diagnostics Event Hub Namespace.')
output diagnosticsEventHubNamespaceResourceId string = diagnosticsEventHubNamespaceModule.outputs.resourceId

@description('The resource ID of the created diagnostics Event Hub Namespace Authorization Rule.')
output diagnosticsEventHubAuthorizationRuleId string = '${diagnosticsEventHubNamespaceModule.outputs.resourceId}/authorizationrules/${diagnosticsEventHubNamespaceAuthorizationRuleName}'

@description('The name of the created diagnostics Event Hub Namespace Event Hub.')
output diagnosticsEventHubNamespaceEventHubName string = diagnosticsEventHubNamespaceModule.outputs.name
