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
# Pro Support

<a href="https://www.opszero.com"><img src="https://assets.opszero.com/images/opszero_11_29_2016.png" width="300px"/></a>

[opsZero provides support](https://www.opszero.com/devops) for our modules including:

- Email support
- Zoom Calls
- Implementation Guidance
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_group_ids"></a> [ad\_group\_ids](#input\_ad\_group\_ids) | ActiveDirectory Groups that have access to this cluster | `list` | `[]` | no |
| <a name="input_ad_user_ids"></a> [ad\_user\_ids](#input\_ad\_user\_ids) | ActiveDirectory users that have access to the kubernetes admin group and attached to the cluster | `list` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The address space that is used the virtual network | `string` | `"10.0.0.0"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The Client ID which should be used when authenticating as a service principal | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The application password to be used when authenticating using a client secret | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of the environment to create resources | `string` | n/a | yes |
| <a name="input_mariadb_sql_enabled"></a> [mariadb\_sql\_enabled](#input\_mariadb\_sql\_enabled) | Specify whether the mariadb is enabled | `bool` | `false` | no |
| <a name="input_mariadb_sql_version"></a> [mariadb\_sql\_version](#input\_mariadb\_sql\_version) | Specify the version of MariaDB to use. Possible values are 10.2 and 10.3 | `string` | `"10.2"` | no |
| <a name="input_nodes_desired_capacity"></a> [nodes\_desired\_capacity](#input\_nodes\_desired\_capacity) | The number of Amazon EC2 instances that should be running in the group | `number` | `1` | no |
| <a name="input_postgres_sql_enabled"></a> [postgres\_sql\_enabled](#input\_postgres\_sql\_enabled) | Specify whether postgres sql is enabled | `bool` | `false` | no |
| <a name="input_postgres_sql_version"></a> [postgres\_sql\_version](#input\_postgres\_sql\_version) | Specify the version of PostgreSQL to use. Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"11"` | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | The size of the Redis cache to deploy | `number` | `1` | no |
| <a name="input_redis_enabled"></a> [redis\_enabled](#input\_redis\_enabled) | Specify whether the redis cluster is enabled | `bool` | `false` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium) | `string` | `"C"` | no |
| <a name="input_redis_shard_count"></a> [redis\_shard\_count](#input\_redis\_shard\_count) | Only available when using the Premium SKU The number of Shards to create on the Redis Cluster | `number` | `0` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | The SKU of Redis to use. Possible values are Basic, Standard and Premium | `string` | `"Standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure Region where the Resource Group should exist. | `string` | `"Central US"` | no |
| <a name="input_registry_enabled"></a> [registry\_enabled](#input\_registry\_enabled) | Specify whether the container registry is enabled | `bool` | `false` | no |
| <a name="input_sql_master_password"></a> [sql\_master\_password](#input\_sql\_master\_password) | The Password associated with the administrator\_login for the PostgreSQL/MariaDB Server | `string` | `""` | no |
| <a name="input_sql_master_username"></a> [sql\_master\_username](#input\_sql\_master\_username) | The Administrator login for the PostgreSQL/MariabDB Server | `string` | `""` | no |
| <a name="input_sql_sku_name"></a> [sql\_sku\_name](#input\_sql\_sku\_name) | Specify the SKU Name for this PostgreSQL Server | `string` | `"GP_Gen5_2"` | no |
| <a name="input_sql_storage_in_mb"></a> [sql\_storage\_in\_mb](#input\_sql\_storage\_in\_mb) | Max storage allowed for a MariaDB server | `number` | `10240` | no |
## Resources

| Name | Type |
|------|------|
| [azuread_group.cluster](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_kubernetes_cluster.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_mariadb_database.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_database) | resource |
| [azurerm_mariadb_server.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_server) | resource |
| [azurerm_mariadb_virtual_network_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_virtual_network_rule) | resource |
| [azurerm_postgresql_database.qa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_server.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) | resource |
| [azurerm_postgresql_virtual_network_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule) | resource |
| [azurerm_redis_cache.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_route_table.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
## Outputs

No outputs.
<!-- END_TF_DOCS -->
