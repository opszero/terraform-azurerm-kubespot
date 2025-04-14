

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.environment_name
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  dns_prefix          = "auditkube"

  default_node_pool {
    name            = "nodes"
    node_count      = var.nodes_desired_capacity
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30

    vnet_subnet_id        = azurerm_subnet.cluster.id
    enable_node_public_ip = true # TURN it off
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
    network_plugin = "azure"
  }

  local_account_disabled = true

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = false
    managed            = true
    admin_group_object_ids = concat(
      length(var.ad_group_ids) > 0 ? var.ad_group_ids : [],
      length(var.ad_user_ids) > 0 ? [azuread_group.cluster[0].object_id] : []
    )
  }

  tags = {
    Environment = var.environment_name
  }
}
