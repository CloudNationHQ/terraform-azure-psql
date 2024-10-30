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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

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
  version = "~> 3.0"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    administrator_password = module.kv.secrets.psql-admin-password.value

    authentication = {
      active_directory_auth_enabled = true
      password_auth_enabled         = true
    }

    ad_admin = {
      # Specifies the AD admin as a Service Principal or User, defaults to ServicePrincipal in the current Terraform run.
      # Set principal_type = "User" when running Terraform using a personal account.
      principal_type = "User"

      # Optional: Specify another AD admin (user or service principal).
      # object_id      = "7e81d148-0000-0000-0000-4ae000b6406e"
      # principal_name = "john.doe@sometenant.onmicrosoft.com"
    }
  }
}
