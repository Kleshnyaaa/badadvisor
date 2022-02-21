@allowed([
  'dev'
  'prod'
])
param environment string
param resourcePostfix string

var vNetCIDR = '10.0.0.0/24'
var appServiceSubnetCIDR = '10.0.0.0/27'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: 'vnet-badadvisor-${environment}-${resourcePostfix}'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetCIDR
      ]
    }
    subnets:[
      {
        name: 'subnet-appservice-badadvisor-${environment}-${resourcePostfix}'
        properties: {
          addressPrefix: appServiceSubnetCIDR
          delegations: [
            {
              name: 'Microsoft.Web.serverFarms'
              type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
    ]
  }
}

output subnetId string = virtualNetwork.properties.subnets[0].id
output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
