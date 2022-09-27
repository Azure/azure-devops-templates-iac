@description('Service principal app registration id')
param servicePrincipalId string = 'UID'

@description('Address prefixes to apply to virtual network during creation process')
param virtualNetworkAddressPrefixes array = [ '172.16.0.0/16' ]

@description('Subnets to create on virtual network during creation process')
param virtualNetworkSubnets array = [{ name: 'default', addressPrefix: '172.16.0.0/24' }]

@description('Tags to apply to the resource group')
param resourceGroupTags object = { test: 'test' }

@description('Tags to apply to virtual network related resources')
param virtualNetworkTags object = { test: 'test' }

@description('Tags to apply to resources')
param keyVaultTags object = { test: 'test' }

var location = resourceGroup().location

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup()
  params: {
    onlyUpdate: bool('false')
    tags: resourceGroupTags
  }
}

module virtualNetwork './modules/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: 'deploy-vnet-${uniqueString(resourceGroup().name)}'
  params: {
    name: 'vnet-${uniqueString(resourceGroup().name)}'
    location: location
    lock: ''
    addressPrefixes: virtualNetworkAddressPrefixes
    subnets: virtualNetworkSubnets
    tags: virtualNetworkTags
  }
}

module vault './modules/Microsoft.KeyVault/vaults/deploy.bicep' = {
  name: 'deploy-kv-${uniqueString(resourceGroup().name)}'
  params: {
    name: 'kv-${uniqueString(resourceGroup().name)}'
    location: location
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
    enableSoftDelete: true
    enablePurgeProtection: true
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
        name: 'kv-pe-${uniqueString(deployment().name)}'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
        service: 'vault'
        tags: keyVaultTags
      }
    ]
    tags: keyVaultTags
    secrets: {}
    keys: []
  }
}
output resourceGroupName string = resourceGroup().name
output location	string = resourceGroup().location
output vnetNameOutput string = virtualNetwork.outputs.name
output vnetIdOutput string = virtualNetwork.outputs.resourceId
output vnetSubnetNames array = virtualNetwork.outputs.subnetNames
output vnetSubnetResourceIds array = virtualNetwork.outputs.subnetResourceIds
output kvName	string = vault.outputs.name
output kvResourceId	string = vault.outputs.resourceId
output kvURI string =  vault.outputs.uri
