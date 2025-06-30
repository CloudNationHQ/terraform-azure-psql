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
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 7.0"

  naming = {
    subnet                 = module.naming.subnet.name
    network_security_group = module.naming.network_security_group.name
    route_table            = module.naming.route_table.name
  }

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.18.0.0/16"]

    subnets = {
      postgresql = {
        cidr = ["10.18.0.0/24"]
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

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 4.0"

  instance = {
    name                          = module.naming.postgresql_server.name_unique
    location                      = module.rg.groups.demo.location
    resource_group                = module.rg.groups.demo.name
    public_network_access_enabled = false

    delegated_subnet_id = module.network.subnets.postgresql.id
    private_dns_zone_id = module.private_dns.private_zones.psql.id

  }
}
