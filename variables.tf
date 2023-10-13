variable "environment_name" {
  type        = string
  description = "Name of the environment to create resources"
}

variable "client_id" {
  type        = string
  description = "The Client ID which should be used when authenticating as a service principal"
}

variable "client_secret" {
  type        = string
  description = "The application password to be used when authenticating using a client secret"
}

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
  default     = false
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
  default     = false
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
  default     = ""
  description = "The Administrator login for the PostgreSQL/MariabDB Server"
}

variable "sql_master_password" {
  default     = ""
  description = "The Password associated with the administrator_login for the PostgreSQL/MariaDB Server"
}
