module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  for_each = {
    for key, kv in local.key_vaults : key => kv
  }

  naming = local.naming

  vault = each.value

}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 9.0"

  naming = local.naming

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      psql = {
        address_prefixes = ["10.18.0.0/24"]
        delegations = {
          psql-delegation = {
            name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        }
      }
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/pdns/azure"
  version = "~> 3.0"

  zones = {
    private = {
      psql = {
        name           = "privatelink.postgres.database.azure.com"
        resource_group = module.rg.groups.demo.name

        virtual_network_links = {
          psql = {
            virtual_network_id = module.network.vnet.id
          }
        }
      }
    }
  }

  depends_on = [module.network]
}

module "identity_primary" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "identity_backup" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = "${module.naming.user_assigned_identity.name}-backup"
    location            = "westeurope"
    resource_group_name = module.rg.groups.demo.name
  }
}

module "identity_replica" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 2.0"

  config = {
    name                = "${module.naming.user_assigned_identity.name}-replica"
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 5.0"

  naming   = local.naming
  instance = local.postgresql_server

  depends_on = [module.network]
}


module "postgresql_replicas" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 5.0"

  naming = local.naming

  for_each = {
    for key, psql in local.postgresql_replicas : key => psql
  }
  instance = each.value

  depends_on = [module.postgresql]
}
