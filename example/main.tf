provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path = "./kubeconfig"
  }
}

module "AKS" {
  source           = "./../"
  environment_name = "prod"
  cluster_name     = "aks"
  prefix           = "aks-prod-eastus"
  location         = "East US"
  address_spaces   = ["10.0.0.0/1"]
  #subnet
  create_nat_gateway = true
  subnet_names       = ["subnet"]
  subnet_prefixes    = ["10.10.0.0/20"]
  # route_table
  enable_route_table = true
  #   route_table_name   = "prod"
  routes = [
    {
      name                   = "prod-routes"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = null
    }
  ]
  # database
  postgres_sql_enabled = false
  # acr-registry
  registry_enabled = true

  default_node_pool = {
    name                   = "defaultnp"
    vm_size                = "Standard_DS2_v2"
    os_disk_type           = "Managed"
    os_disk_size_gb        = 30
    auto_scaling_enabled   = false
    node_public_ip_enabled = false
    count                  = 1
    min_count              = 1
    max_count              = 3
    max_pods               = 110
    type                   = "VirtualMachineScaleSets"
  }

  nodes_pools = [
    {
      name            = "np1"
      vm_size         = "Standard_DS2_v2"
      os_type         = "Linux"
      os_disk_type    = "Managed"
      os_disk_size_gb = 30

      auto_scaling_enabled   = false
      node_count             = 5
      min_count              = 5
      max_count              = 6
      max_pods               = 110
      node_public_ip_enabled = false
      mode                   = "User"
      orchestrator_version   = "1.28.3"
      node_taints            = []
      host_group_id          = null
    },
    {
      name                   = "np2"
      vm_size                = "Standard_DS2_v2"
      os_type                = "Linux"
      os_disk_type           = "Managed"
      os_disk_size_gb        = 30
      auto_scaling_enabled   = false
      node_count             = 1
      min_count              = 1
      max_count              = 2
      max_pods               = 110
      node_public_ip_enabled = false
      mode                   = "User"
      orchestrator_version   = "1.28.3"
      node_taints            = []
      host_group_id          = null
    }
  ]
}



module "helm-common" {
  source             = "github.com/opszero/terraform-helm-kubespot"
  cert_manager_email = "ops@opszero.com"
  nginx_min_replicas = 1
  nginx_max_replicas = 3
}

