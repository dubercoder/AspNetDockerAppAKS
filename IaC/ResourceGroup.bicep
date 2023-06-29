targetScope = 'subscription'
param location string 
param resourceGroupName string 

resource resource_group 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name:resourceGroupName
  location: location
}
