module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "northeurope"
    }
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.7"

  naming = local.naming

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    fw_rules = {
      sales = {
        start_ip_address = "10.20.30.1"
        end_ip_address   = "10.20.30.255"
      }
      hr = {
        start_ip_address = "10.20.31.1"
        end_ip_address   = "10.20.31.255"
      }
    }
  }
}
