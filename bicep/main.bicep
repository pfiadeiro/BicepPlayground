targetScope = 'subscription'

@minLength(1)
@maxLength(90)
@description('Required. The name of the Resource Group')
param rgName string

@description('Optional. Resource Group location')
param rgLocation string = 'uksouth'

@minLength(3)
@maxLength(24)
@description('Required.The name of the storage account 3-24	Lowercase letters and numbers.')
param storageAccountName string

@description('Optional. An array of container names')
param storageAccountContainers array = [] 

var tags = {
  role: 'Testing'
  owner: 'Pedro Fiadeiro'
  bicep: true
}

module resourceGroup 'Resources/resourceGroup.bicep' = {
  name: 'deploy-${rgName}'
  params: {
    location: rgLocation
    name: rgName
    tags: tags
  }
}

module storageaccount 'Resources/Storage/storageV2.bicep' = {
  scope: az.resourceGroup(rgName)
  name: 'storageaccount${storageAccountName}-deploy'
  params: {
    name: storageAccountName
    location: rgLocation
    isHnsEnabled: true
    networkAclsBypass: 'AzureServices'
    skuName: 'Standard_LRS'
    tags: tags
  }
  dependsOn:[
    resourceGroup
  ]
}


module container 'Resources/Storage/StorageAccountContainer.bicep' = [for container in storageAccountContainers: {
  scope: az.resourceGroup(rgName)
  name: '${container}-deploy'
  params: {
    parent: storageAccountName
    containerName: container
  }
  dependsOn: [
    storageaccount
  ]
}]

