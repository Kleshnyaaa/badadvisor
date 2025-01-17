@allowed([
  'dev'
  'prod'
])
param environmentTier string
param resourcePostfix string
param location string
param subnetId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'sabadadvisor${environmentTier}${resourcePostfix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: subnetId
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
    }
  }
}

var storageAccountFirstKey = storageAccount.listKeys().keys[0]
output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccountFirstKey.value};EndpointSuffix=${environment().suffixes.storage}'
