@allowed([
  'dev'
  'prod'
])
param environmentTier string
param resourcePostfix string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'sabadadvisor${environmentTier}${resourcePostfix}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

var storageAccountFirstKey = storageAccount.listKeys().keys[0]
output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountFirstKey.keyName};AccountKey=${storageAccountFirstKey.value};EndpointSuffix=${environment().suffixes.storage}'
