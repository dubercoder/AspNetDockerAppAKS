//Declaramos los parametros necesarios
param acrName string
param location string = resourceGroup().location

//Creamos el ACR
resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name:'Premium'
  }
  properties: {
    adminUserEnabled: true
  }
}

//Generamos el output que usaremos en el módulo del AKS.

output acrid string = acr.id
