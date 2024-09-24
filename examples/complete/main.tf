module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  for_each = {
    for key, kv in local.key_vaults : key => kv
  }

  naming = local.naming

  vault = each.value

}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.18.0.0/16"]

    subnets = {
      psql = {
        cidr = ["10.18.0.0/24"]
        delegations = {
          psql-delegation = {
            name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          }
        }
      }
    }
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 2.0"

  naming = local.naming

  for_each = {
    for key, psql in local.postgresql_servers : key => psql
  }
  instance = each.value

  depends_on = [module.network]
}


module "postgresql_replicas" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 2.0"

  naming = local.naming

  for_each = {
    for key, psql in local.postgresql_replicas : key => psql
  }
  instance = each.value

  depends_on = [module.postgresql]
}

module "private_dns" {
  source  = "cloudnationhq/psql/azure//modules/private-dns"
  version = "~> 2.0"

  providers = {
    azurerm = azurerm.connectivity
  }

  zone = {
    name           = "privatelink.postgres.database.azure.com"
    resource_group = "rg-dns-shared-001"
    vnet           = module.network.vnet.id
  }
}
