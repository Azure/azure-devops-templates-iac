@description('Tags to apply to the resource group.')
param resourceGroupTags object = { test: 'test' }

@description('Name of the key vault to create')
param recoveryServiceVaultName string = 'test'

@description('Tags to apply to recovery service vault related resources')
param recoveryServiceVaultTags object = { test: 'test' }

@description('Configuration for diagnostic settings')
param diagnosticsSettings object = { subscriptionId: subscription().id, resourceGroupName: resourceGroup().name, logAnalyticsWorkspaceName: 'test', storageAccountName: 'test', eventHubNamespaceName: 'test', eventHubNamespaceAuthorizationRuleName: 'RootManageSharedAccessKey'}

var backupResourceGroupName = resourceGroup().name
var backupResourceGroupLocation = resourceGroup().location

var diagnosticsWorkspaceId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.OperationalInsights/workspaces', diagnosticsSettings.logAnalyticsWorkspaceName)
var diagnosticsStorageAccountId = resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.Storage/storageAccounts', diagnosticsSettings.storageAccountName)
var diagnosticsEventHubAuthorizationRuleId = '${resourceId(diagnosticsSettings.subscriptionId, diagnosticsSettings.resourceGroupName, 'Microsoft.EventHub/namespaces', diagnosticsSettings.eventHubNamespaceName)}/authorizationrules/${diagnosticsSettings.eventHubNamespaceAuthorizationRuleName}'

module resourceGroupTag './modules/Microsoft.Resources/tags/resourceGroups/deploy.bicep' = {
  name: 'deploy-rgtags-${uniqueString(resourceGroup().name)}'
  scope: resourceGroup(backupResourceGroupName)
  params: {
    onlyUpdate: bool('true')
    tags: resourceGroupTags
  }
}

module recoveryServiceVaultModule './modules/Microsoft.RecoveryServices/vaults/deploy.bicep' = {
  scope: resourceGroup(backupResourceGroupName)
  name: 'deploy-rsv-${uniqueString(resourceGroup().name)}'
  params: {
    name: recoveryServiceVaultName
    lock: ''
    location: backupResourceGroupLocation
    backupStorageConfig: {
      crossRegionRestoreFlag: true
      storageModelType: 'GeoRedundant'
    }
    backupPolicies: [
      {
        name: 'VMpolicy'
        properties: {
          backupManagementType: 'AzureIaasVM'
          instantRPDetails: {}
          instantRpRetentionRangeInDays: 2
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 180
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            monthlySchedule: {
              retentionDuration: {
                count: 60
                durationType: 'Months'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
            weeklySchedule: {
              daysOfTheWeek: [
                'Sunday'
              ]
              retentionDuration: {
                count: 12
                durationType: 'Weeks'
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
            yearlySchedule: {
              monthsOfYear: [
                'January'
              ]
              retentionDuration: {
                count: 10
                durationType: 'Years'
              }
              retentionScheduleFormatType: 'Weekly'
              retentionScheduleWeekly: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                weeksOfTheMonth: [
                  'First'
                ]
              }
              retentionTimes: [
                '2019-11-07T07:00:00Z'
              ]
            }
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T07:00:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
        }
      }
      {
        name: 'sqlpolicy'
        properties: {
          backupManagementType: 'AzureWorkload'
          protectedItemsCount: 0
          settings: {
            isCompression: true
            issqlcompression: true
            timeZone: 'UTC'
          }
          subProtectionPolicy: [
            {
              policyType: 'Full'
              retentionPolicy: {
                monthlySchedule: {
                  retentionDuration: {
                    count: 60
                    durationType: 'Months'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                retentionPolicyType: 'LongTermRetentionPolicy'
                weeklySchedule: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  retentionDuration: {
                    count: 104
                    durationType: 'Weeks'
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
                yearlySchedule: {
                  monthsOfYear: [
                    'January'
                  ]
                  retentionDuration: {
                    count: 10
                    durationType: 'Years'
                  }
                  retentionScheduleFormatType: 'Weekly'
                  retentionScheduleWeekly: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    weeksOfTheMonth: [
                      'First'
                    ]
                  }
                  retentionTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                }
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Sunday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2019-11-07T22:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Differential'
              retentionPolicy: {
                retentionDuration: {
                  count: 30
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                schedulePolicyType: 'SimpleSchedulePolicy'
                scheduleRunDays: [
                  'Monday'
                ]
                scheduleRunFrequency: 'Weekly'
                scheduleRunTimes: [
                  '2017-03-07T02:00:00Z'
                ]
                scheduleWeeklyFrequency: 0
              }
            }
            {
              policyType: 'Log'
              retentionPolicy: {
                retentionDuration: {
                  count: 15
                  durationType: 'Days'
                }
                retentionPolicyType: 'SimpleRetentionPolicy'
              }
              schedulePolicy: {
                scheduleFrequencyInMins: 120
                schedulePolicyType: 'LogSchedulePolicy'
              }
            }
          ]
          workLoadType: 'SQLDataBase'
        }
      }
      {
        name: 'filesharepolicy'
        properties: {
          backupManagementType: 'AzureStorage'
          protectedItemsCount: 0
          retentionPolicy: {
            dailySchedule: {
              retentionDuration: {
                count: 30
                durationType: 'Days'
              }
              retentionTimes: [
                '2019-11-07T04:30:00Z'
              ]
            }
            retentionPolicyType: 'LongTermRetentionPolicy'
          }
          schedulePolicy: {
            schedulePolicyType: 'SimpleSchedulePolicy'
            scheduleRunFrequency: 'Daily'
            scheduleRunTimes: [
              '2019-11-07T04:30:00Z'
            ]
            scheduleWeeklyFrequency: 0
          }
          timeZone: 'UTC'
          workloadType: 'AzureFileShare'
        }
      }
    ]

    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticsStorageAccountId
    diagnosticWorkspaceId: diagnosticsWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticsEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticsSettings.eventHubNamespaceName
    systemAssignedIdentity: true
    tags: recoveryServiceVaultTags
  }
}

@description('Name of the backup resource group in which the resources are deployed.')
output backupResourceGroupName string = backupResourceGroupName

@description('Location of the backup resource group.')
output backupResourceGroupLocation	string = backupResourceGroupLocation

@description('Name of the recovery service vault.')
output backupRecoveryServiceVaultName	string = recoveryServiceVaultModule.outputs.name

@description('Location of the recovery service vault.')
output backupRecoveryServiceVaultLocation	string = recoveryServiceVaultModule.outputs.location

@description('ResourceID of the recovery service vault.')
output backupRecoveryServiceVaultResourceId	string = recoveryServiceVaultModule.outputs.resourceId

@description('ID of the system assigned managed identity of the recovery service vault.')
output backupRecoveryServiceVaultSystemMSIId	string = recoveryServiceVaultModule.outputs.systemAssignedPrincipalId
