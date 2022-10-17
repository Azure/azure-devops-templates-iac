@description('Tags to apply to the resource group')
param resourceGroupTags object = { test: 'test' }

@description('Name of the virtual network to create')
param virtualNetworkName string = 'vnet-default'

@description('Address prefixes to apply to virtual network during creation process')
param virtualNetworkAddressPrefixes array = [ '172.16.0.0/16' ]

@description('Subnets to create on virtual network during creation process')
param virtualNetworkSubnets array = [{ name: 'default', addressPrefix: '172.16.0.0/24', networkSecurityGroupName: 'nsg-default', routeTableName: '', natGatewayName: '' , serviceEndpoints: [], delegations: [], privateEndpointNetworkPolicies: 'Disabled', privateLinkServiceNetworkPolicies: 'Disabled' }]

@description('Tags to apply to virtual network related resources')
param virtualNetworkTags object = { test: 'test' }

@description('Configurations for NSG resources')
param networkSecurityGroups array = [{name: 'nsg-default', tags: { test: 'test' }, securityRules: [] }]

@description('Tags to apply to route table related resources')
param routeTables array = [{name: 'rt-default', tags: { test: 'test' }, routes: [], disableBgpRoutePropagation: true }]

@description('Configuration for diagnostic settings')
param diagnosticsSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, logAnalyticsWorkspaceName: 'test', storageAccountName: 'test', eventHubNamespaceName: 'test', eventHubNamespaceAuthorizationRuleName: 'RootManageSharedAccessKey'}

var networkResourceGroupName = resourceGroup().name
var networkResourceGroupLocation = resourceGroup().location

var diagnosticsWorkspaceId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.OperationalInsights/workspaces', diagnosticsSettings.logAnalyticsWorkspaceName)
var diagnosticsStorageAccountId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.Storage/storageAccounts', diagnosticsSettings.storageAccountName)
var diagnosticsEventHubAuthorizationRuleId = '${resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.EventHub/namespaces', diagnosticsSettings.eventHubNamespaceName)}/authorizationrules/${diagnosticsSettings.eventHubNamespaceAuthorizationRuleName}'

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(networkResourceGroupName)
  params: {
    onlyUpdate: bool('true')
    tags: resourceGroupTags
  }
}

module networkSecurityGroupModule './modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = [for nsg in networkSecurityGroups: {
  name: 'deploy-nsg-${nsg.name}-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(networkResourceGroupName)
  params: {
    name: nsg.name
    location: networkResourceGroupLocation
    lock: ''
    securityRules: nsg.securityRules
    tags: nsg.tags
    diagnosticWorkspaceId: diagnosticsWorkspaceId
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
  }
}]

module routeTableModule './modules/Microsoft.Network/routeTables/deploy.bicep' = [for rt in routeTables: {
  name: 'deploy-rt-${rt.name}-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(networkResourceGroupName)
  params: {
    name: rt.name
    location: networkResourceGroupLocation
    lock: ''
    routes: rt.routes
    disableBgpRoutePropagation: rt.disableBgpRoutePropagation
    tags: rt.tags
  }
}]

module virtualNetworkModule './modules/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: 'deploy-virtualnetwork-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(networkResourceGroupName)
  params: {
    name: virtualNetworkName
    location: networkResourceGroupLocation
    lock: ''
    addressPrefixes: virtualNetworkAddressPrefixes
    subnets: [for subnet in virtualNetworkSubnets: {
      name: subnet.name
      addressPrefix: subnet.addressPrefix
      networkSecurityGroupId: (subnet.networkSecurityGroupName == '' ?  '' : resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups' , subnet.networkSecurityGroupName))
      routeTableId: (subnet.routeTableName == '' ? '' : resourceId(resourceGroup().name, 'Microsoft.Network/routeTables' , subnet.routeTableName))
      serviceEndpoints: subnet.serviceEndpoints
      delegations: subnet.delegations
      privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
      privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
    }]
    tags: virtualNetworkTags
    diagnosticWorkspaceId: diagnosticsWorkspaceId
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
  }
  dependsOn: [
    networkSecurityGroupModule
    routeTableModule
  ]
}

@description('Name of the network resource group in which the resources are deployed.')
output networkResourceGroupName string = resourceGroup().name

@description('Location of the network resource group.')
output networkResourceGroupLocation	string = networkResourceGroupLocation

@description('Name of the created virtual network.')
output virtualNetworkNameOutput string = virtualNetworkModule.outputs.name

@description('Resource ID of the created virtual network.')
output virtualNetworkIdOutput string = virtualNetworkModule.outputs.resourceId

@description('Array of names of the created subnets.')
output virtualNetworkSubnetNames array = virtualNetworkModule.outputs.subnetNames

@description('Array of resource IDs of the created subnets.')
output virtualNetworkSubnetResourceIds array = virtualNetworkModule.outputs.subnetResourceIds

@description('Array of the created network security groups.')
output networkSecurityGroups array = [for (nsg,i) in networkSecurityGroups: {
  resourceGroupName: networkSecurityGroupModule[i].outputs.resourceGroupName
  name: networkSecurityGroupModule[i].outputs.name
  resourceId: networkSecurityGroupModule[i].outputs.resourceId
  location: networkSecurityGroupModule[i].outputs.location
}]

@description('Array of the created route tables.')
output routeTables array = [for (rt,i) in routeTables: {
  resourceGroupName: routeTableModule[i].outputs.resourceGroupName
  name: routeTableModule[i].outputs.name
  resourceId: routeTableModule[i].outputs.resourceId
  location: routeTableModule[i].outputs.location
}]
