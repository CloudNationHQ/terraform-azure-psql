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
      location = "northeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

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

  instance = {
    name                          = module.naming.postgresql_server.name_unique
    location                      = module.rg.groups.demo.location
    resource_group                = module.rg.groups.demo.name
    public_network_access_enabled = false

    network = {
      delegated_subnet_id = module.network.subnets.postgresql.id
      private_dns_zone_id = module.private_dns.zone.id
    }
  }
}

module "private_dns" {
  source  = "cloudnationhq/psql/azure//modules/private-dns"
  version = "~> 2.0"

  providers = {
    azurerm = azurerm.connectivity
  }

  zone = {
    name          = "privatelink.postgres.database.azure.com"
    resourcegroup = "rg-dns-shared-001"
    vnet          = module.network.vnet.id
  }
}
