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
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.1"

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

    ad_admin = {
      ## This is the ServicePrincipal or User that will be set as AD admin,
      ## if not defined it defaults to ServicePrincipal under the current Terraform run,
      ## if ran under a personal user, always provide the principal_type = "User".
      principal_type = "User"
      ## Optional values to add another user or service principal as an AD admin (instead of current).
      # object_id      = "7e81d148-0000-0000-0000-4ae000b6406e"
      # principal_name = "john.doe@sometenant.onmicrosoft.com"
    }
  }
}
