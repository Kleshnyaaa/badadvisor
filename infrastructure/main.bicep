param environment string 
param resourcePostfix string

var location = resourceGroup().location

module storageAccount 'resources/storageAccount.bicep' = {
  name: 'storageAccount-deployment'
  params: {
    environmentTier: environment
    resourcePostfix: resourcePostfix
  }
}

var connectionString = storageAccount.outputs.connectionString

module appService 'resources/appService.bicep' = {
  name: 'appService-deployment'
  params: {
    environmentTier: environment
    resourcePostfix: resourcePostfix
    location: location
    connectionString: connectionString
  }
}
