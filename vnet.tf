resource "azurerm_virtual_network" "default" {
  name                 = "${var.environment_name}-vnet"
  location             = var.location
  resource_group_name  = azurerm_resource_group.default.id
  address_space        = var.address_spaces
  dns_servers          = var.dns_servers
  tags                 = merge(var.default_tags, merge(var.default_tags, var.tags))

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_pp && var.existing_ddos_pp == null ? [1] : []
    content {
      id     = azurerm_network_ddos_protection_plan.main[0].id
      enable = true
    }
  }

  # dynamic "encryption" {
  #   for_each = var.enforcement != null ? [true] : []
  #   content {
  #     enforcement = var.enforcement
  #   }
  # }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}

# Optional DDOS plan resource
resource "azurerm_network_ddos_protection_plan" "main" {
  count               = var.enable_ddos_pp && var.existing_ddos_pp == null ? 1 : 0
  name                = "${var.environment_name}-ddos-plan"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.id
  tags                = merge(var.default_tags, merge(var.default_tags, var.tags))
}


locals {
  subnet = var.specific_name_subnet == false ? length(var.subnet_names) : length(var.specific_subnet_names)
}

resource "azurerm_subnet" "subnet" {
  count                                         =  local.subnet
  name                                          = var.specific_name_subnet == false ? "${var.environment_name}-${element(var.subnet_names, count.index)}" : var.specific_subnet_names[0]
  resource_group_name                           =  azurerm_resource_group.default.id
  address_prefixes                              = [var.subnet_prefixes[count.index]]
  virtual_network_name                          = azurerm_virtual_network.default.name
  service_endpoints                             = var.service_endpoints
  service_endpoint_policy_ids                   = var.service_endpoint_policy_ids
  # private_link_service_network_policies_enabled = var.subnet_enforce_private_link_service_network_policies
  # private_endpoint_network_policies             = var.private_endpoint_network_policies
  # default_outbound_access_enabled               = var.default_outbound_access_enabled

  dynamic "delegation" {
    for_each = var.delegation
    content {
      name = delegation.key
      dynamic "service_delegation" {
        for_each = toset(delegation.value)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

resource "azurerm_public_ip" "pip" {
  count               =  var.create_nat_gateway ? 1 : 0
  name                = format("%s-nat-gateway-ip", var.environment_name)
  allocation_method   = var.allocation_method
  location            = var.location
  resource_group_name =  azurerm_resource_group.default.id
  sku                 = var.sku
  tags                = merge(var.default_tags, var.tags)
}

resource "azurerm_nat_gateway" "natgw" {
  count                   =  var.create_nat_gateway ? 1 : 0
  name                    = format("%s-nat-gateway", var.environment_name)
  location                = var.location
  resource_group_name     =  azurerm_resource_group.default.id
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout
  zones                   = var.zones
  tags                    = merge(var.default_tags, var.tags)
}

resource "azurerm_nat_gateway_public_ip_association" "pip_assoc" {
  count                =  var.create_nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.natgw[0].id
  public_ip_address_id = azurerm_public_ip.pip[0].id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  count          =  var.create_nat_gateway ? local.subnet : 0
  nat_gateway_id = azurerm_nat_gateway.natgw[0].id
  subnet_id      = element(azurerm_subnet.subnet[*].id, count.index)
}

resource "azurerm_route_table" "rt" {
  count                         =  var.enable_route_table ? 1 : 0
  name                          = var.route_table_name == null ? format("%s-route-table", var.environment_name) : format("%s-%s-route-table", var.environment_name, var.route_table_name)
  location                      = var.location
  resource_group_name           =  azurerm_resource_group.default.id
  # bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = merge(var.default_tags, var.tags)

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
}

resource "azurerm_subnet_route_table_association" "main" {
  count          =  var.enable_route_table ? local.subnet : 0
  subnet_id      = element(azurerm_subnet.subnet[*].id, count.index)
  route_table_id = azurerm_route_table.rt[0].id
}