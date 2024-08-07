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
  version = "~> 1.0"

  instance = {
    name           = module.naming.postgresql_server.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}
