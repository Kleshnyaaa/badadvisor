param environment string 
param resourcePostfix string

param location string = resourceGroup().location

module virtualNetwork 'resources/vnet.bicep' = {
  name: 'vNet'
  params: {
    environment: environment
    resourcePostfix: resourcePostfix
  }
}

module storageAccount 'resources/storageAccount.bicep' = {
  name: 'storageAccount-deployment'
  params: {
    environmentTier: environment
    resourcePostfix: resourcePostfix
    location: location
    subnetId: virtualNetwork.outputs.subnetId
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
    vnetName: virtualNetwork.outputs.vnetName
  }
}
