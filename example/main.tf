provider "azurerm" {
  features {}
  subscription_id = ""
}

#######################################################AKS###################################################
module "AKS" {
  source           = "./../"
  environment_name = "prod"
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
}





