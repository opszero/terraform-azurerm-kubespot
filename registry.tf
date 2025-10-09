resource "azurerm_container_registry" "acr" {
  count = var.registry_enabled ? 1 : 0

  name                = var.registry_name
  location            = azurerm_resource_group.default[count.index].location
  resource_group_name = azurerm_resource_group.default[count.index].name
  sku                 = "Premium"
  admin_enabled       = var.acr_admin_enabled

  dynamic "georeplications" {
    for_each = [
      for loc in ["East US", "West Europe"] :
      loc if lower(replace(loc, " ", "")) != lower(replace(azurerm_resource_group.default[count.index].location, " ", ""))
    ]
    content {
      location = georeplications.value
    }
  }
}
