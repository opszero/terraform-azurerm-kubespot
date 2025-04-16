# output "subnet_id" {
#   value = azurerm_subnet.cluster.id
# }

output "resource_group_name" {
  value = azurerm_resource_group.default[0].name
}