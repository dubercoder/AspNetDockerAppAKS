@description('El ambiente a desplegar dev, test, prod...')
param prefix string 
@description('Nombre del cluster AKS')
param clusterName string 
@description('region')
param location string = resourceGroup().location
@description('Kubernetes version ')
param kubernetesVersion string
@description('Tamano de maquina por nodo')
param nodeVmSize string
@minValue(1)
@maxValue(50)
@description('Numero de nodos')
param nodeCount int 

@maxValue(100)
@description('Maximo de nodos a escalar')
param maxNodeCount int 

@description('Nombre del pool')
param nodePoolName string

@minValue(0)
@maxValue(1023)
@description('Tamano en GB del disco')
param osDiskSizeGB int 

@description('Zonas de disponibilidad de AZ')
param availabilityZones array = [
  '1'
]
@description('Permine o deniega autoescalar')
param enableAutoScaling bool = true

@description('Nombre del ACR a utilizar')
param acrName string

@description('Network plugin para  Kubernetes network')
param networkPlugin string
@description('Cluster services IP range')
param serviceCidr string 
@description('DNS Service IP address')
param dnsServiceIP string 
@description('Docker Bridge IP range')
param dockerBridgeCidr string 
@description('Un array de AAD group object ids para administracion')
param adminGroupObjectIDs array = []

// Parametros de Networking
param vnetName string 
param subnetName string 
param resourceGroupNet string 

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetName
  scope: resourceGroup(resourceGroupNet)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: subnetName
  parent: vnet
}

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview'  existing = {
  name: acrName
}


resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-08-03-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }  
  properties: {
    nodeResourceGroup: 'rg-${prefix}-aks-nodes-${clusterName}-${location}'
    kubernetesVersion: kubernetesVersion
    dnsPrefix: '${clusterName}-dns'
    enableRBAC: true    
    agentPoolProfiles: [
      {        
        name: nodePoolName
        osDiskSizeGB: osDiskSizeGB
        osDiskType: 'Managed'       
        count: nodeCount
        enableAutoScaling: enableAutoScaling
        minCount: nodeCount
        maxCount: maxNodeCount
        vmSize: nodeVmSize        
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        osSKU: 'Ubuntu'
        mode: 'System'
        availabilityZones: availabilityZones
        vnetSubnetID: subnet.id
      }
    ]
    networkProfile: {      
      loadBalancerSku: 'Standard'
      networkPlugin: networkPlugin
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      dockerBridgeCidr: dockerBridgeCidr
    }
    securityProfile: { }
    oidcIssuerProfile: {
      enabled: false
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    aadProfile: !empty(adminGroupObjectIDs) ? {
      managed: true
      adminGroupObjectIDs: adminGroupObjectIDs
    } : null
  }
 
}

// Asignar el Rol para permitir Pull de imagenes de docker desde el container al AKS.

var acrPullRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')


resource acrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksCluster.id, acrPullRoleDefinitionId)
  scope: acr
  properties: {
    description: 'Permisos AcrPull role hacia AKS'
    principalId:aksCluster.properties.identityProfile.kubeletidentity.objectId
    principalType:'ServicePrincipal'
    roleDefinitionId:acrPullRoleDefinitionId
  }
}
