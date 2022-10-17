targetScope = 'subscription'

@minLength(1)
@maxLength(90)
@description('Required. The name of the Resource Group')
param name string

@description('Required. The location that the resource should be created')
param location string

@description('Optional. The tags that should be added to the resource')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
  tags: tags
}

output resourceGroupName string = resourceGroup.name
