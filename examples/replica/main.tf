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

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 2.0"

  instance = {
    name           = module.naming.postgresql_server.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku_name       = "GP_Standard_D2s_v3"
  }
}

module "postgresql_repl" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 2.0"

  instance = {
    name           = join("-", [module.naming.postgresql_server.name, "repl"])
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku_name       = "GP_Standard_D2s_v3"

    create_mode      = "Replica"
    source_server_id = module.postgresql.postgresql_server.id
  }
}
