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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.2"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

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
  #source  = "cloudnationhq/psql/azure"
  #version = "~> 0.1"
  source = "../../"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    admin_password = module.kv.secrets.psql-admin-password.value
    key_vault_id   = module.kv.vault.id

    enabled = {
      ad_auth = true
      pw_auth = true
    }

    ad_admin = { ## This is the service principal that will be set as AD admin on the PostgreSQL server, if not defined the Service Principal of the Terraform run will be used
      object_id      = "063ad969-6d01-4c45-a8d9-bf66a0b7646c"
      principal_name = "dennis.kool_cloudnation.nl#EXT#@dkool.onmicrosoft.com"
      principal_type = "User"
    }
  }
}
