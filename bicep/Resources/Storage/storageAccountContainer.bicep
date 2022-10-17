@minLength(3)
@maxLength(63)
@description('Required. The name of the storage account container 3-63	Lowercase letters, numbers and hyphens starting with a letter or numer.')
param containerName string
param parent string

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${parent}/default/${containerName}'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}
