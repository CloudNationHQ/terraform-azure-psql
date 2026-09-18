module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 10.0"

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      postgresql = {
        name             = "${module.naming.subnet.name}-postgresql"
        address_prefixes = ["10.18.0.0/24"]
        delegations = {
          psql = {
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
  version = "~> 5.0"

  resource_group_name = module.rg.groups.demo.name

  zones = {
    private = {
      psql = {
        name = "privatelink.postgres.database.azure.com"

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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    secrets = {
      random_string = {
        psql-admin-password = {
          length      = 16
          special     = false
          min_special = 0
          min_upper   = 2
        }
      }
    }
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 6.0"

  postgresql = {
    name                = module.naming.postgresql_server.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    administrator_login           = "psqladmin"
    administrator_password        = module.kv.secrets.psql-admin-password.value
    public_network_access_enabled = false

    delegated_subnet_id = module.network.subnets.postgresql.id
    private_dns_zone_id = module.private_dns.private_zones.psql.id

  }
}
