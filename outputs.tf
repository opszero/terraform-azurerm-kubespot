output "subnet_id" {
  value = azurerm_subnet.subnet[0].id
}

output "resource_group_name" {
  value       = azurerm_resource_group.default[0].name
  description = "The name of the created resource group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.default[0].location
  description = "The location of the created resource group"
}

output "vnet_id" {
  value       = azurerm_virtual_network.default[0].id
  description = "The ID of the created Virtual Network"
}

output "subnet_ids" {
  value       = [for subnet in azurerm_subnet.subnet : subnet.id]
  description = "The IDs of the created subnets"
}

output "nat_gateway_id" {
  value       = azurerm_nat_gateway.natgw[0].id
  description = "The ID of the NAT Gateway"
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks[0].name
  description = "The name of the AKS cluster"
}

output "aks_kube_config" {
  value       = azurerm_kubernetes_cluster.aks[0].kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig for the AKS cluster"
}

output "aks_fqdn" {
  value       = azurerm_kubernetes_cluster.aks[0].fqdn
  description = "FQDN of the AKS cluster"
}

output "redis_id" {
  value       = length(azurerm_redis_cache.default) > 0 ? azurerm_redis_cache.default[0].id : null
  description = "ID of the Redis cache"
}


output "registry_name" {
  value       = azurerm_container_registry.acr[0].name
  description = "Name of the Azure Container Registry"
}
