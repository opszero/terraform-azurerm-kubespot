resource "azurerm_resource_group" "default" {
  name     = "${var.environment_name}-rg"
  location = var.location
  tags     = merge(var.default_tags, var.tags)

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}

resource "azurerm_management_lock" "default" {
  count      = var.resource_lock_enabled ? 1 : 0
  name       = "${var.lock_level}-rg-lock"
  scope      = azurerm_resource_group.default.id
  lock_level = var.lock_level
  notes      = var.notes
}