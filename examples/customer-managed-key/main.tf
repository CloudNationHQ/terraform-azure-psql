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

  naming = local.naming

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    keys = {
      psql = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]

        policy = {
          rotation = {
            expire_after         = "P90D"
            notify_before_expiry = "P30D"
            automatic = {
              time_after_creation = "P83D"
              time_before_expiry  = "P30D"
            }
          }
        }
      }
    }
  }
}

module "kv_backup" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 4.0"

  naming = local.naming

  vault = {
    name                = "${module.naming.key_vault.name_unique}-bck"
    location            = "westeurope"
    resource_group_name = module.rg.groups.demo.name

    keys = {
      psql = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]

        policy = {
          rotation = {
            expire_after         = "P90D"
            notify_before_expiry = "P30D"
            automatic = {
              time_after_creation = "P83D"
              time_before_expiry  = "P30D"
            }
          }
        }
      }
    }
  }
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
    name                = "${module.naming.user_assigned_identity.name}-bck"
    location            = "westeurope"
    resource_group_name = module.rg.groups.demo.name
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 5.0"

  naming = local.naming

  instance = {
    name                = module.naming.postgresql_server.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    geo_redundant_backup_enabled = true

    customer_managed_key = {
      primary = {
        key_vault_id              = module.kv.vault.id
        key_vault_key_id          = module.kv.keys.psql.id
        principal_id              = module.identity_primary.config.principal_id
        user_assigned_identity_id = module.identity_primary.config.id
      }
      backup = {
        key_vault_id              = module.kv_backup.vault.id
        key_vault_key_id          = module.kv_backup.keys.psql.id
        principal_id              = module.identity_backup.config.principal_id
        user_assigned_identity_id = module.identity_backup.config.id
      }
    }
  }
}
