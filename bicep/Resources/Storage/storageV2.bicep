@minLength(3)
@maxLength(24)
@description('Required. The name of the storage account 3-24	Lowercase letters and numbers.')
param name string

@description('Optional. The location - uses the resource group location by default')
param location string = resourceGroup().location

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
@description('Required. Sku for the storage account')
param skuName string

@description('Required. Account HierarchicalNamespace enabled - This allows the collection of objects/files within an account to be organized into a hierarchy of directories and nested subdirectories in the same way that the file system on your computer is organized. With a hierarchical namespace enabled, a storage account becomes capable of providing the scalability and cost-effectiveness of object storage, with file system semantics that are familiar to analytics engines and frameworks')
param isHnsEnabled bool

@description('Optional. Allows https traffic only to storage service')
param supportsHttpsTrafficOnly bool = true

@allowed([
  'AzureServices'
  'Logging'
  'Metrics'
  'None'
])
@description('Required. Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging|Metrics|AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.')
param networkAclsBypass string


@allowed([
  'Allow'
  'Deny'
])
@description('Specifies the default action of allow or deny when no other rules match.')
param defaultAction string = 'Deny'

@allowed([
  'Cool'
  'Hot'
])
@description('Optional. The access tier used for billing')
param accessTier string = 'Hot'

@description('Optional. The tags that should be added to the resource')
param tags object = {}

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: isHnsEnabled
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'

    networkAcls: {
      bypass: networkAclsBypass
      defaultAction: defaultAction
    }
    accessTier: accessTier
  }
  tags: tags
}

output storageID string = storage.id
output storagePrimaryEndpoints object = storage.properties.primaryEndpoints
