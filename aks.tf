
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  resource_group_name = var.resource_group_name
  location            = var.location
}


resource "azurerm_kubernetes_cluster" "aks" {
  count                             = var.enabled ? 1 : 0
  name                              = "${var.environment_name}-aks"
  location                          = azurerm_resource_group.default[0].location
  resource_group_name               = azurerm_resource_group.default[0].name
  dns_prefix                        = var.prefix
  kubernetes_version                = var.kubernetes_version
  sku_tier                          = var.aks_sku_tier
  node_resource_group               = var.node_resource_group
  disk_encryption_set_id            = var.key_vault_id != "" ? join("", azurerm_disk_encryption_set.main[*].id) : null
  private_cluster_enabled           = var.private_cluster_enabled
  private_dns_zone_id               = var.private_cluster_enabled && var.private_dns_zone_type == "Custom" ? var.private_dns_zone_id : var.private_dns_zone_type
  http_application_routing_enabled  = var.enable_http_application_routing
  azure_policy_enabled              = var.enable_azure_policy
  edge_zone                         = var.edge_zone
  image_cleaner_enabled             = var.image_cleaner_enabled
  image_cleaner_interval_hours      = var.image_cleaner_interval_hours
  role_based_access_control_enabled = var.role_based_access_control_enabled
  local_account_disabled            = var.local_account_disabled

  default_node_pool {
    name                   = var.default_node_pool.name
    node_count             = var.default_node_pool.count
    vm_size                = var.default_node_pool.vm_size
    auto_scaling_enabled   = var.default_node_pool.auto_scaling_enabled
    min_count              = var.default_node_pool.min_count
    max_count              = var.default_node_pool.max_count
    max_pods               = var.default_node_pool.max_pods
    os_disk_type           = var.default_node_pool.os_disk_type
    os_disk_size_gb        = var.default_node_pool.os_disk_size_gb
    type                   = var.default_node_pool.type
    vnet_subnet_id         = azurerm_subnet.subnet[0].id
    node_public_ip_enabled = var.default_node_pool.node_public_ip_enabled

    dynamic "upgrade_settings" {
      for_each = var.upgrade_settings_enabled ? [var.upgrade_settings_values] : []

      content {
        max_surge                     = upgrade_settings.value.max_surge
        drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
        node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes
      }
    }
  }


  dynamic "oms_agent" {
    for_each = var.oms_agent_enabled ? ["oms_agent"] : []

    content {
      log_analytics_workspace_id      = azurerm_log_analytics_workspace.main[0].id
      msi_auth_for_monitoring_enabled = var.msi_auth_for_monitoring_enabled
    }
  }


  identity {
    type = var.private_cluster_enabled && var.private_dns_zone_type == "Custom" ? "UserAssigned" : "SystemAssigned"
  }

  dynamic "linux_profile" {
    for_each = var.linux_profile != null ? [true] : []
    content {
      admin_username = var.linux_profile.username
      ssh_key {
        key_data = var.linux_profile.ssh_key
      }
    }
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    dns_service_ip    = cidrhost(var.service_cidr, 10)
    service_cidr      = var.service_cidr
    load_balancer_sku = "standard"
    outbound_type     = var.outbound_type
  }

  depends_on = [azurerm_role_assignment.aks_uai_private_dns_zone_contributor]
  tags       = merge(var.default_tags, merge(var.default_tags, var.tags))
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each               = { for np in var.nodes_pools : np.name => np }
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks[0].id
  name                   = each.value.name
  vm_size                = each.value.vm_size
  os_type                = each.value.os_type
  os_disk_type           = each.value.os_disk_type
  os_disk_size_gb        = each.value.os_disk_size_gb
  vnet_subnet_id         = azurerm_subnet.subnet[0].id
  auto_scaling_enabled   = each.value.auto_scaling_enabled
  node_count             = each.value.node_count
  min_count              = each.value.min_count
  max_count              = each.value.max_count
  max_pods               = each.value.max_pods
  node_public_ip_enabled = each.value.node_public_ip_enabled
  mode                   = each.value.mode
  orchestrator_version   = each.value.orchestrator_version
  node_taints            = each.value.node_taints
  host_group_id          = each.value.host_group_id
}


resource "azurerm_role_assignment" "aks_system_identity" {
  count                = var.enabled && var.cmk_enabled ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.aks[0].identity[0].principal_id
  scope                = join("", azurerm_disk_encryption_set.main[*].id)
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

resource "azurerm_role_assignment" "aks_acr_access_principal_id" {
  count                = var.enabled && var.registry_enabled ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.aks[0].identity[0].principal_id
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
}

resource "azurerm_role_assignment" "aks_acr_access_object_id" {
  count                = var.enabled && var.registry_enabled ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.aks[0].kubelet_identity[0].object_id
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
}

resource "azurerm_role_assignment" "aks_user_assigned" {
  count                = var.enabled ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.aks[0].kubelet_identity[0].object_id
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, join("", azurerm_kubernetes_cluster.aks[*].node_resource_group))
  role_definition_name = "Network Contributor"
}

resource "azurerm_user_assigned_identity" "aks_user_assigned_identity" {
  count = var.enabled && var.private_cluster_enabled && var.private_dns_zone_type == "Custom" ? 1 : 0

  name                = format("aks-%s-identity", var.cluster_name)
  resource_group_name = local.resource_group_name
  location            = local.location
}


resource "azurerm_role_assignment" "aks_uai_private_dns_zone_contributor" {
  count = var.enabled && var.private_cluster_enabled && var.private_dns_zone_type == "Custom" ? 1 : 0

  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = join("", azurerm_user_assigned_identity.aks_user_assigned_identity[*].principal_id)
}

resource "azurerm_role_assignment" "aks_uai_vnet_network_contributor" {
  count                = var.enabled && var.private_cluster_enabled && var.private_dns_zone_type == "Custom" ? 1 : 0
  scope                = azurerm_virtual_network.default[0].id
  role_definition_name = "Network Contributor"
  principal_id         = join("", azurerm_user_assigned_identity.aks_user_assigned_identity[*].principal_id)
}

resource "azurerm_key_vault_key" "example" {
  count        = var.enabled && var.cmk_enabled ? 1 : 0
  name         = format("aks-%s-vault-key", var.cluster_name)
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "main" {
  count               = var.enabled && var.cmk_enabled ? 1 : 0
  name                = format("aks-%s-dsk-encrpt", var.cluster_name)
  resource_group_name = local.resource_group_name
  location            = local.location
  key_vault_key_id    = var.key_vault_id != "" ? join("", azurerm_key_vault_key.example[*].id) : null

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "azurerm_disk_encryption_set_key_vault_access" {
  count                = var.enabled && var.cmk_enabled ? 1 : 0
  principal_id         = azurerm_disk_encryption_set.main[0].identity[0].principal_id
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}

resource "azurerm_key_vault_access_policy" "main" {
  count = var.enabled && var.cmk_enabled ? 1 : 0

  key_vault_id = var.key_vault_id

  tenant_id = azurerm_disk_encryption_set.main[0].identity[0].tenant_id
  object_id = azurerm_disk_encryption_set.main[0].identity[0].principal_id
  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
  certificate_permissions = [
    "Get"
  ]
}


resource "azurerm_key_vault_access_policy" "key_vault" {
  count = var.enabled && var.cmk_enabled ? 1 : 0

  key_vault_id = var.key_vault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_kubernetes_cluster.aks[0].key_vault_secrets_provider[0].secret_identity[0].object_id

  key_permissions         = ["Get"]
  certificate_permissions = ["Get"]
  secret_permissions      = ["Get"]
}

resource "azurerm_key_vault_access_policy" "kubelet_identity" {
  count = var.enabled && var.cmk_enabled ? 1 : 0

  key_vault_id = var.key_vault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_kubernetes_cluster.aks[0].kubelet_identity[0].object_id

  key_permissions         = ["Get"]
  certificate_permissions = ["Get"]
  secret_permissions      = ["Get"]

}