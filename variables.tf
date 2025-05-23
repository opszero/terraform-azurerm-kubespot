variable "location" {
  description = "The Azure region where the resource group will be created."
  default     = "East US"
  type        = string
}

variable "default_tags" {
  description = "Base tags applied to all resources"
  type        = map(string)
  default = {
    ManagedBy    = "OpsZero"
    Repositories = "https://github.com/opszero/terraform-azurerm-kubespot"
  }
}

variable "tags" {
  description = "Additional tags that override or extend default_tags"
  type        = map(string)
  default     = {}
}


variable "enabled" {
  description = "Enable resource group creation and related resources."
  type        = bool
  default     = true
}

variable "resource_lock_enabled" {
  description = "Flag to enable resource lock on the resource group."
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "The level of the lock. Can be 'CanNotDelete' or 'ReadOnly'."
  type        = string
  default     = "CanNotDelete"
}

variable "notes" {
  description = "Optional notes about the lock."
  type        = string
  default     = "Resource group lock to prevent accidental deletion"
}

variable "timeouts" {
  description = "Timeout values for resource group operations."
  type = object({
    create = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}

variable "environment_name" {
  type        = string
  default     = ""
  description = "Name of the environment to create resources"
}



#vnat

variable "address_spaces" {
  description = "List of address spaces for the VNet"
  default     = ["null"]
  type        = list(string)
}


variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "enable_ddos_pp" {
  description = "Enable creation of a new DDoS protection plan"
  type        = bool
  default     = false
}
variable "enable" {
  description = "Enable creation of a new DDoS protection plan"
  type        = bool
  default     = true
}

variable "azurerm_resource_group_enabled" {
  description = "Enable creation of a new DDoS protection plan"
  type        = bool
  default     = true
}

variable "existing_ddos_pp" {
  description = "Use an existing DDoS protection plan ID"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Use an existing DDoS protection plan ID"
  type        = string
  default     = ""
}


# Specific subnet names if needed
variable "specific_name_subnet" {
  type    = bool
  default = false
}

variable "specific_subnet_names" {
  type    = list(string)
  default = []
}

# Subnet prefixes for address allocation
variable "subnet_prefixes" {
  type    = list(string)
  default = []
}

# Subnet names
variable "subnet_names" {
  type    = list(string)
  default = []
}

# Service Endpoints for subnet
variable "service_endpoints" {
  type    = list(string)
  default = []
}

# Service Endpoint Policy IDs for subnet
variable "service_endpoint_policy_ids" {
  type    = list(string)
  default = null
}

# Delegation of subnet resources
variable "delegation" {
  type = map(list(object({
    name = string
    service_delegation = list(object({
      name    = string
      actions = list(string)
    }))
  })))
  default = {}
}

# Flag to create NAT Gateway
variable "create_nat_gateway" {
  type    = bool
  default = false
}

# Allocation method for the public IP
variable "allocation_method" {
  type    = string
  default = "Static"
}


# SKU for the Public IP
variable "sku" {
  type    = string
  default = "Standard"
}


# SKU for NAT Gateway
variable "sku_name" {
  type    = string
  default = "Standard"
}

# Timeout in minutes for idle NAT Gateway
variable "nat_gateway_idle_timeout" {
  type    = number
  default = 4
}

# Zones for NAT Gateway
variable "zones" {
  type    = list(string)
  default = []
}

# Flag to enable Route Table
variable "enable_route_table" {
  type    = bool
  default = false
}

# Name of the route table
variable "route_table_name" {
  type    = string
  default = null
}

# Routes to be added to the route table
variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
  default = []
}



variable "kubernetes_version" {
  type        = string
  default     = "1.32.2"
  description = "Version of Kubernetes to deploy"
}

variable "aks_sku_tier" {
  type        = string
  default     = "Free"
  description = "aks sku tier. Possible values are Free ou Paid"
}

variable "private_cluster_enabled" {
  type        = bool
  default     = false
  description = "Configure AKS as a Private Cluster : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#private_cluster_enabled"
}

variable "node_resource_group" {
  type        = string
  default     = null
  description = "Name of the resource group in which to put AKS nodes. If null default to MC_<AKS RG Name>"
}

variable "private_dns_zone_type" {
  type        = string
  default     = null
  description = ""
}



variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "Id of the private DNS Zone when <private_dns_zone_type> is custom"
}


variable "linux_profile" {
  description = "Username and ssh key for accessing AKS Linux nodes with ssh."
  type = object({
    username = string,
    ssh_key  = string
  })
  default = null
}

variable "service_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR used by kubernetes services (kubectl get svc)."
}

variable "outbound_type" {
  type        = string
  default     = "loadBalancer"
  description = "The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer` and `userDefinedRouting`."
}


variable "enable_http_application_routing" {
  type        = bool
  default     = false
  description = "Enable HTTP Application Routing Addon (forces recreation)."
}

variable "enable_azure_policy" {
  type        = bool
  default     = true
  description = "Enable Azure Policy Addon."
}



variable "network_plugin" {
  type        = string
  default     = "azure"
  description = "Network plugin to use for networking."
}

variable "network_policy" {
  type        = string
  default     = null
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
}


variable "acr_id" {
  type        = string
  default     = ""
  description = "azure container resource id to provide access for aks"
}

variable "key_vault_id" {
  type        = string
  default     = ""
  description = "Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret"
}

# Diagnosis Settings Enable

variable "cmk_enabled" {
  type        = bool
  default     = false
  description = "Flag to control resource creation related to cmk encryption."
}



# variable "client_id" {
#   type        = string
#   description = "The Client ID which should be used when authenticating as a service principal"
# }
#
# variable "client_secret" {
#   type        = string
#   description = "The application password to be used when authenticating using a client secret"
# }

variable "ad_group_ids" {
  description = "ActiveDirectory Groups that have access to this cluster"
  default     = []
}

variable "ad_user_ids" {
  description = "ActiveDirectory users that have access to the kubernetes admin group and attached to the cluster"
  default     = []
}

# variable "cluster_version" {
#   default = "1.13"
# }

# variable "cluster_username" {
# }
# variable "cluster_password" {
# }

variable "region" {
  default     = "Central US"
  description = "The Azure Region where the Resource Group should exist."
}

variable "cidr" {
  default     = "10.0.0.0"
  description = "The address space that is used the virtual network"
}

# variable "zones" {
#   default = ["us-central1-a", "us-central1-b"]
# }

# # TODO
# variable "eips" {
#   default = []
# }

# variable "nodes_green_instance_type" {
#   default = "n1-standard-1"
# }

variable "nodes_desired_capacity" {
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group"
}

# variable "nodes_green_min_size" {
#   default = 1
# }

# variable "nodes_green_max_size" {
#   default = 1
# }

# variable "nodes_blue_instance_type" {
#   default = "t2.micro"
# }

# variable "nodes_blue_desired_capacity" {
#   default = 1
# }

# variable "nodes_blue_min_size" {
#   default = 1
# }

# variable "nodes_blue_max_size" {
#   default = 1
# }

# //the following below are required for setting up the vpn
# variable "foxpass_api_key" {
#   type    = "string"
#   default = ""
# }

# variable "foxpass_vpn_psk" {
#   type        = "string"
#   description = "use this for psk generation https://cloud.google.com/vpn/docs/how-to/generating-pre-shared-key"
#   default     = ""
# }

variable "registry_enabled" {
  default     = true
  description = "Specify whether the container registry is enabled"
}

variable "redis_enabled" {
  default     = false
  description = "Specify whether the redis cluster is enabled"
}

variable "redis_capacity" {
  default     = 1
  description = "The size of the Redis cache to deploy"
}

variable "redis_shard_count" {
  default     = 0
  description = "Only available when using the Premium SKU The number of Shards to create on the Redis Cluster"
}

variable "redis_family" {
  default     = "C"
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

variable "redis_sku_name" {
  default     = "Standard"
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium"
}

variable "mariadb_sql_enabled" {
  default     = true
  description = "Specify whether the mariadb is enabled"
}

variable "mariadb_sql_version" {
  default     = "10.2"
  description = "Specify the version of MariaDB to use. Possible values are 10.2 and 10.3"
}

variable "postgres_sql_enabled" {
  default     = false
  description = "Specify whether postgres sql is enabled"
}

variable "registry_name" {
  type    = string
  default = "acrprodtyj"
}

variable "postgres_sql_version" {
  default     = "11"
  description = "Specify the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11"
}

variable "sql_sku_name" {
  default     = "GP_Gen5_2"
  description = "Specify the SKU Name for this PostgreSQL Server"
}

variable "sql_storage_in_mb" {
  default     = 10240
  description = "Max storage allowed for a MariaDB server"
}

variable "sql_master_username" {
  default     = "prod"
  description = "The Administrator login for the PostgreSQL/MariabDB Server"
}

variable "sql_master_password" {
  default     = ""
  description = "The Password associated with the administrator_login for the PostgreSQL/MariaDB Server"
}



variable "default_node_pool" {
  description = "Default node pool configuration"
  type = object({
    name                   = string
    vm_size                = string
    os_disk_type           = string
    os_disk_size_gb        = number
    auto_scaling_enabled   = bool
    node_public_ip_enabled = bool
    count                  = number
    min_count              = number
    max_count              = number
    max_pods               = number
    type                   = string
  })
}

variable "nodes_pools" {
  description = "List of additional node pools"
  type = list(object({
    name                   = string
    vm_size                = string
    os_type                = string
    os_disk_type           = string
    os_disk_size_gb        = number
    auto_scaling_enabled   = bool
    node_count             = number
    min_count              = number
    max_count              = number
    max_pods               = number
    node_public_ip_enabled = bool
    mode                   = string
    orchestrator_version   = string
    node_taints            = list(string)
    host_group_id          = string
    #    capacity_reservation_group_id = string
    #    workload_runtime              = string
    #    zones                         = list(string)
  }))
  default = []
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "Specifies the Edge Zone within the Azure Region where this Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created."
}

variable "image_cleaner_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether Image Cleaner is enabled."
}

variable "image_cleaner_interval_hours" {
  type        = number
  default     = 48
  description = "(Optional) Specifies the interval in hours when images should be cleaned up. Defaults to `48`."
}

variable "role_based_access_control_enabled" {
  type        = bool
  default     = true
  description = "Whether role based acces control should be enabled or not"
}

variable "local_account_disabled" {
  type        = bool
  default     = false
  description = "Whether local account should be disable or not"
}

variable "cluster_name" {
  type    = string
  default = "aks"
}

variable "prefix" {
  type        = string
  default     = ""
  description = "(Optional) The prefix for the resources created in the specified Azure Resource Group. Omitting this variable requires both `var.cluster_log_analytics_workspace_name` and `var.cluster_name` have been set. Only one of `var.prefix,var.dns_prefix_private_cluster` can be specified."
}