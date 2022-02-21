@allowed([
  'dev'
  'prod'
])
param environmentTier string
param resourcePostfix string
param connectionString string
param location string
param vnetName string
param subnetId string

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-badadvisor-${environmentTier}-${resourcePostfix}'
  location: location
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  kind: 'linux'
  properties: {
    maximumElasticWorkerCount: 1
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: 'appservice-badadvisor-${environmentTier}-${resourcePostfix}'
  location: location
  properties: {
    serverFarmId: plan.id
    enabled: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|5.0'
      alwaysOn: true
      vnetName: vnetName
      vnetRouteAllEnabled: true
    }
    virtualNetworkSubnetId: subnetId
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource appConfiguration 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'web'
  parent: appService
  properties: {
    appSettings: [
      {
        name: 'StorageConnectionString'
        value: connectionString
      }
    ]
  }
}
