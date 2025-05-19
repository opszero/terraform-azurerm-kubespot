resource "azurerm_log_analytics_workspace" "main" {
  count                      = var.oms_agent_enabled || var.create_log_analytics_workspace == true ? 1 : 0
  name                       = format("%s-law", var.environment_name)
  location                   = azurerm_resource_group.default[0].location
  resource_group_name        = azurerm_resource_group.default[0].name
  sku                        = var.log_analytics_workspace_sku
  retention_in_days          = var.retention_in_days
  daily_quota_gb             = var.daily_quota_gb
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled
  tags                       = merge(var.default_tags, merge(var.default_tags, var.tags))
}