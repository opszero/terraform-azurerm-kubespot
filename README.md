<!-- BEGIN_TF_DOCS -->
# Kubespot (Azure)

<img src="http://assets.opszero.com/images/auditkube.png" width="200px" />

Compliance Oriented Kubernetes Setup for AWS, Google Cloud and Microsoft Azure.

Kubespot is an open source terraform module that attempts to create a complete
compliance-oriented Kubernetes setup on AWS, Google Cloud and Azure. These add
additional security such as additional system logs, file system monitoring, hard
disk encryption and access control. Further, we setup the managed Redis and SQL
on each of the Cloud providers with limited access to the Kubernetes cluster so
things are further locked down. All of this should lead to setting up a HIPAA /
PCI / SOC2 being made straightforward and repeatable.

This covers how we setup your infrastructure on AWS, Google Cloud and Azure.
These are the three Cloud Providers that we currently support to run Kubernetes.
Further, we use the managed service provided by each of the Cloud Providers.
This document covers everything related to how infrastructure is setup within
each Cloud, how we create an isolated environment for Compliance and the
commonalities between them.

# Tools & Setup

```
brew install kubectl kubernetes-helm google-cloud-sdk terraform
```

# Keys

How to get key for cluster creation (client id and secret)

1. Sign in to Azure portal
2. Navigate to the Azure Active Directory
3. Select "App registrations"
4. If there is application already use existing one or create new one as follows
5. Click on the "New registration" button to create a new application registration
6. select the appropriate supported account type (e.g., "Accounts in this organizational directory only")
7. Click on the "Register" button to create the application.
8. After application is created, Under "Certificates & secrets," click on the "New client secret" button to create a new client secret.
9. Copy the client id and client secret and pass it to cluster creation opszero module

# Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

# Teardown

```sh
terraform destroy -auto-approve
```
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.34.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | azure container resource id to provide access for aks | `string` | `""` | no |
| <a name="input_ad_group_ids"></a> [ad\_group\_ids](#input\_ad\_group\_ids) | ActiveDirectory Groups that have access to this cluster | `list` | `[]` | no |
| <a name="input_ad_user_ids"></a> [ad\_user\_ids](#input\_ad\_user\_ids) | ActiveDirectory users that have access to the kubernetes admin group and attached to the cluster | `list` | `[]` | no |
| <a name="input_address_spaces"></a> [address\_spaces](#input\_address\_spaces) | List of address spaces for the VNet | `list(string)` | <pre>[<br/>  "null"<br/>]</pre> | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | aks sku tier. Possible values are Free ou Paid | `string` | `"Free"` | no |
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method) | Allocation method for the public IP | `string` | `"Static"` | no |
| <a name="input_azurerm_resource_group_enabled"></a> [azurerm\_resource\_group\_enabled](#input\_azurerm\_resource\_group\_enabled) | Enable creation of a new DDoS protection plan | `bool` | `true` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The address space that is used the virtual network | `string` | `"10.0.0.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"aks"` | no |
| <a name="input_cmk_enabled"></a> [cmk\_enabled](#input\_cmk\_enabled) | Flag to control resource creation related to cmk encryption. | `bool` | `false` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Flag to create NAT Gateway | `bool` | `false` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Default node pool configuration | <pre>object({<br/>    name                   = string<br/>    vm_size                = string<br/>    os_disk_type           = string<br/>    os_disk_size_gb        = number<br/>    auto_scaling_enabled   = bool<br/>    node_public_ip_enabled = bool<br/>    count                  = number<br/>    min_count              = number<br/>    max_count              = number<br/>    max_pods               = number<br/>    type                   = string<br/>  })</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Base tags applied to all resources | `map(string)` | <pre>{<br/>  "ManagedBy": "OpsZero",<br/>  "Repositories": "https://github.com/opszero/terraform-azurerm-kubespot"<br/>}</pre> | no |
| <a name="input_delegation"></a> [delegation](#input\_delegation) | Delegation of subnet resources | <pre>map(list(object({<br/>    name = string<br/>    service_delegation = list(object({<br/>      name    = string<br/>      actions = list(string)<br/>    }))<br/>  })))</pre> | `{}` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers | `list(string)` | `[]` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | Specifies the Edge Zone within the Azure Region where this Managed Kubernetes Cluster should exist. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable creation of a new DDoS protection plan | `bool` | `true` | no |
| <a name="input_enable_azure_policy"></a> [enable\_azure\_policy](#input\_enable\_azure\_policy) | Enable Azure Policy Addon. | `bool` | `true` | no |
| <a name="input_enable_ddos_pp"></a> [enable\_ddos\_pp](#input\_enable\_ddos\_pp) | Enable creation of a new DDoS protection plan | `bool` | `false` | no |
| <a name="input_enable_http_application_routing"></a> [enable\_http\_application\_routing](#input\_enable\_http\_application\_routing) | Enable HTTP Application Routing Addon (forces recreation). | `bool` | `false` | no |
| <a name="input_enable_route_table"></a> [enable\_route\_table](#input\_enable\_route\_table) | Flag to enable Route Table | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable resource group creation and related resources. | `bool` | `true` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment to create resources | `string` | `""` | no |
| <a name="input_existing_ddos_pp"></a> [existing\_ddos\_pp](#input\_existing\_ddos\_pp) | Use an existing DDoS protection plan ID | `string` | `null` | no |
| <a name="input_image_cleaner_enabled"></a> [image\_cleaner\_enabled](#input\_image\_cleaner\_enabled) | (Optional) Specifies whether Image Cleaner is enabled. | `bool` | `false` | no |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | (Optional) Specifies the interval in hours when images should be cleaned up. Defaults to `48`. | `number` | `48` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes to deploy | `string` | `"1.32.2"` | no |
| <a name="input_linux_profile"></a> [linux\_profile](#input\_linux\_profile) | Username and ssh key for accessing AKS Linux nodes with ssh. | <pre>object({<br/>    username = string,<br/>    ssh_key  = string<br/>  })</pre> | `null` | no |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled) | Whether local account should be disable or not | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource group will be created. | `string` | `"East US"` | no |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | The level of the lock. Can be 'CanNotDelete' or 'ReadOnly'. | `string` | `"CanNotDelete"` | no |
| <a name="input_mariadb_sql_enabled"></a> [mariadb\_sql\_enabled](#input\_mariadb\_sql\_enabled) | Specify whether the mariadb is enabled | `bool` | `true` | no |
| <a name="input_mariadb_sql_version"></a> [mariadb\_sql\_version](#input\_mariadb\_sql\_version) | Specify the version of MariaDB to use. Possible values are 10.2 and 10.3 | `string` | `"10.2"` | no |
| <a name="input_nat_gateway_idle_timeout"></a> [nat\_gateway\_idle\_timeout](#input\_nat\_gateway\_idle\_timeout) | Timeout in minutes for idle NAT Gateway | `number` | `4` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin to use for networking. | `string` | `"azure"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_node_resource_group"></a> [node\_resource\_group](#input\_node\_resource\_group) | Name of the resource group in which to put AKS nodes. If null default to MC\_<AKS RG Name> | `string` | `null` | no |
| <a name="input_nodes_desired_capacity"></a> [nodes\_desired\_capacity](#input\_nodes\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group | `number` | `1` | no |
| <a name="input_nodes_pools"></a> [nodes\_pools](#input\_nodes\_pools) | List of additional node pools | <pre>list(object({<br/>    name                   = string<br/>    vm_size                = string<br/>    os_type                = string<br/>    os_disk_type           = string<br/>    os_disk_size_gb        = number<br/>    auto_scaling_enabled   = bool<br/>    node_count             = number<br/>    min_count              = number<br/>    max_count              = number<br/>    max_pods               = number<br/>    node_public_ip_enabled = bool<br/>    mode                   = string<br/>    orchestrator_version   = string<br/>    node_taints            = list(string)<br/>    host_group_id          = string<br/>    #    capacity_reservation_group_id = string<br/>    #    workload_runtime              = string<br/>    #    zones                         = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_notes"></a> [notes](#input\_notes) | Optional notes about the lock. | `string` | `"Resource group lock to prevent accidental deletion"` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are `loadBalancer` and `userDefinedRouting`. | `string` | `"loadBalancer"` | no |
| <a name="input_postgres_sql_enabled"></a> [postgres\_sql\_enabled](#input\_postgres\_sql\_enabled) | Specify whether postgres sql is enabled | `bool` | `false` | no |
| <a name="input_postgres_sql_version"></a> [postgres\_sql\_version](#input\_postgres\_sql\_version) | Specify the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"11"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Optional) The prefix for the resources created in the specified Azure Resource Group. Omitting this variable requires both `var.cluster_log_analytics_workspace_name` and `var.cluster_name` have been set. Only one of `var.prefix,var.dns_prefix_private_cluster` can be specified. | `string` | `""` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Configure AKS as a Private Cluster : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#private_cluster_enabled | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Id of the private DNS Zone when <private\_dns\_zone\_type> is custom | `string` | `null` | no |
| <a name="input_private_dns_zone_type"></a> [private\_dns\_zone\_type](#input\_private\_dns\_zone\_type) | n/a | `string` | `null` | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | The size of the Redis cache to deploy | `number` | `1` | no |
| <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled) | Specify whether the redis cluster is enabled | `bool` | `false` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium) | `string` | `"C"` | no |
| <a name="input_redis_shard_count"></a> [redis\_shard\_count](#input\_redis\_shard\_count) | Only available when using the Premium SKU The number of Shards to create on the Redis Cluster | `number` | `0` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | The SKU of Redis to use. Possible values are Basic, Standard and Premium | `string` | `"Standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure Region where the Resource Group should exist. | `string` | `"Central US"` | no |
| <a name="input_registry_enabled"></a> [registry\_enabled](#input\_registry\_enabled) | Specify whether the container registry is enabled | `bool` | `true` | no |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | n/a | `string` | `"acrprodtyj"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Use an existing DDoS protection plan ID | `string` | `""` | no |
| <a name="input_resource_lock_enabled"></a> [resource\_lock\_enabled](#input\_resource\_lock\_enabled) | Flag to enable resource lock on the resource group. | `bool` | `false` | no |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | Whether role based acces control should be enabled or not | `bool` | `true` | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | Name of the route table | `string` | `null` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Routes to be added to the route table | <pre>list(object({<br/>    name                   = string<br/>    address_prefix         = string<br/>    next_hop_type          = string<br/>    next_hop_in_ip_address = string<br/>  }))</pre> | `[]` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | CIDR used by kubernetes services (kubectl get svc). | `string` | `"10.0.0.0/16"` | no |
| <a name="input_service_endpoint_policy_ids"></a> [service\_endpoint\_policy\_ids](#input\_service\_endpoint\_policy\_ids) | Service Endpoint Policy IDs for subnet | `list(string)` | `null` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Service Endpoints for subnet | `list(string)` | `[]` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU for the Public IP | `string` | `"Standard"` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU for NAT Gateway | `string` | `"Standard"` | no |
| <a name="input_specific_name_subnet"></a> [specific\_name\_subnet](#input\_specific\_name\_subnet) | Specific subnet names if needed | `bool` | `false` | no |
| <a name="input_specific_subnet_names"></a> [specific\_subnet\_names](#input\_specific\_subnet\_names) | n/a | `list(string)` | `[]` | no |
| <a name="input_sql_master_password"></a> [sql\_master\_password](#input\_sql\_master\_password) | The Password associated with the administrator\_login for the PostgreSQL/MariaDB Server | `string` | `""` | no |
| <a name="input_sql_master_username"></a> [sql\_master\_username](#input\_sql\_master\_username) | The Administrator login for the PostgreSQL/MariabDB Server | `string` | `"prod"` | no |
| <a name="input_sql_sku_name"></a> [sql\_sku\_name](#input\_sql\_sku\_name) | Specify the SKU Name for this PostgreSQL Server | `string` | `"GP_Gen5_2"` | no |
| <a name="input_sql_storage_in_mb"></a> [sql\_storage\_in\_mb](#input\_sql\_storage\_in\_mb) | Max storage allowed for a MariaDB server | `number` | `10240` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | Subnet names | `list(string)` | `[]` | no |
| <a name="input_subnet_prefixes"></a> [subnet\_prefixes](#input\_subnet\_prefixes) | Subnet prefixes for address allocation | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags that override or extend default\_tags | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout values for resource group operations. | <pre>object({<br/>    create = optional(string, "30m")<br/>    read   = optional(string, "5m")<br/>    update = optional(string, "30m")<br/>    delete = optional(string, "30m")<br/>  })</pre> | `{}` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones for NAT Gateway | `list(string)` | `[]` | no |
## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_disk_encryption_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_access_policy.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kubelet_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.node_pools](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_management_lock.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_nat_gateway.natgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.pip_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_ddos_protection_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_postgresql_database.qa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_server.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) | resource |
| [azurerm_postgresql_virtual_network_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_redis_cache.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_acr_access_object_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_acr_access_principal_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_system_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_uai_private_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_uai_vnet_network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_user_assigned](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.azurerm_disk_encryption_set_key_vault_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.subnet_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_route_table_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_user_assigned_identity.aks_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | The name of the AKS cluster |
| <a name="output_aks_fqdn"></a> [aks\_fqdn](#output\_aks\_fqdn) | FQDN of the AKS cluster |
| <a name="output_aks_kube_config"></a> [aks\_kube\_config](#output\_aks\_kube\_config) | Raw kubeconfig for the AKS cluster |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | The ID of the NAT Gateway |
| <a name="output_redis_id"></a> [redis\_id](#output\_redis\_id) | ID of the Redis cache |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | Name of the Azure Container Registry |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The location of the created resource group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the created resource group |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The IDs of the created subnets |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the created Virtual Network |
# 🚀 Built by opsZero!

<a href="https://opszero.com"><img src="https://opszero.com/wp-content/uploads/2024/07/opsZero_logo_svg.svg" width="300px"/></a>

Since 2016 [opsZero](https://opszero.com) has been providing Kubernetes
expertise to companies of all sizes on any Cloud. With a focus on AI and
Compliance we can say we seen it all whether SOC2, HIPAA, PCI-DSS, ITAR,
FedRAMP, CMMC we have you and your customers covered.

We provide support to organizations in the following ways:

- [Modernize or Migrate to Kubernetes](https://opszero.com/solutions/modernization/)
- [Cloud Infrastructure with Kubernetes on AWS, Azure, Google Cloud, or Bare Metal](https://opszero.com/solutions/cloud-infrastructure/)
- [Building AI and Data Pipelines on Kubernetes](https://opszero.com/solutions/ai/)
- [Optimizing Existing Kubernetes Workloads](https://opszero.com/solutions/optimized-workloads/)

We do this with a high-touch support model where you:

- Get access to us on Slack, Microsoft Teams or Email
- Get 24/7 coverage of your infrastructure
- Get an accelerated migration to Kubernetes

Please [schedule a call](https://calendly.com/opszero-llc/discovery) if you need support.

<br/><br/>

<div style="display: block">
  <img src="https://opszero.com/wp-content/uploads/2024/07/aws-advanced.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-public-sector.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-eks.png" width="150px" />
</div>
<!-- END_TF_DOCS -->
