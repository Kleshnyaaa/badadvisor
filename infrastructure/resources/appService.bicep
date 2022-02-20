@allowed([
  'dev'
  'prod'
])
param environment string
param resourcePostfix string

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-badadvisor-${environment}-${resourcePostfix}'
  location: resourceGroup().location
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
  name: 'appservice-badadvisor-${environment}-${resourcePostfix}'
  location: resourceGroup().location
  properties: {
    serverFarmId: plan.id
    enabled: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|5.0'
      alwaysOn: true

      appSettings:[
        {
          name: 'test-prop'
          value: 'test-value'
        }
      ]
    }
  }
}
