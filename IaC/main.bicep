targetScope = 'subscription'
//Parametros Transversales y de AKS 
param resourceGroupName string 
param location string 
param clusterName string 
param acrName string
param kubernetesVersion string
param maxNodeCount int
param nodeCount int
param nodePoolName string 
param osDiskSizeGB int
param nodeVmSize string
param prefix string
param resourceGroupNet string
param subnetName string
param vnetName string
param enableAutoScaling bool
param networkPlugin string
param serviceCidr string
param dnsServiceIP string 
param dockerBridgeCidr string

//Grupo de recursos principal
module ResourceGroupDeploy 'ResourceGroup.bicep' = {
  name: 'deployToResourceGroup'
  params: {
   location: location 
   resourceGroupName: resourceGroupName
  }
}



module acrRegistryDeploy 'acr.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: acrName
  params: {
    location: location
    acrName: acrName
  }
  dependsOn: [
    ResourceGroupDeploy
  ]
}


module aksClusterDeploy 'aks.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: clusterName
  params: {
    clusterName: clusterName
    kubernetesVersion: kubernetesVersion
    maxNodeCount: maxNodeCount
    vnetName: vnetName
    nodeCount: nodeCount
    nodePoolName: nodePoolName
    acrName: acrName
    enableAutoScaling: enableAutoScaling
    nodeVmSize:nodeVmSize
    dnsServiceIP: dnsServiceIP
    serviceCidr: serviceCidr
    osDiskSizeGB:osDiskSizeGB
    dockerBridgeCidr: dockerBridgeCidr
    networkPlugin: networkPlugin
    prefix:prefix
    resourceGroupNet:resourceGroupNet
    subnetName:subnetName
    location: location
  }
  dependsOn: [
    ResourceGroupDeploy
    acrRegistryDeploy
  ]
}



