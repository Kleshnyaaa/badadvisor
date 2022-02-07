@allowed([
  'dev'
  'prod'
])
param environment string
param resourcePostfix string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'sabadadvisor${environment}${resourcePostfix}'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
