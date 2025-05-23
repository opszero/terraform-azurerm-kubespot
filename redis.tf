 resource "azurerm_redis_cache" "default" {
   count = var.redis_enabled ? 1 : 0

   name                = var.environment_name
   location            = azurerm_resource_group.default[count.index].location
   resource_group_name = azurerm_resource_group.default[count.index].name
   capacity            = var.redis_capacity
   family              = var.redis_family
   sku_name            = var.redis_sku_name
   non_ssl_port_enabled = false
   shard_count         = var.redis_shard_count

   redis_configuration {
     maxmemory_reserved = 2
     maxmemory_delta    = 2
     maxmemory_policy   = "allkeys-lru"
   }
 }
