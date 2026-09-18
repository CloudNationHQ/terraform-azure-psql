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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"


  vault = {
    name                     = module.naming.key_vault.name_unique
    location                 = module.rg.groups.demo.location
    resource_group_name      = module.rg.groups.demo.name
    purge_protection_enabled = true

    keys = {
      psql = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]

        rotation_policy = {
          expire_after         = "P90D"
          notify_before_expiry = "P30D"
          automatic = {
            time_after_creation = "P83D"
            time_before_expiry  = "P30D"
          }
        }
      }
    }

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

module "kv_backup" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

  vault = {
    name                     = "${module.naming.key_vault.name_unique}-bck"
    location                 = "westeurope"
    resource_group_name      = module.rg.groups.demo.name
    purge_protection_enabled = true

    keys = {
      psql = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]

        rotation_policy = {
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

module "identity_primary" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 3.0"

  identity = {
    name                = module.naming.user_assigned_identity.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "identity_backup" {
  source  = "cloudnationhq/uai/azure"
  version = "~> 3.0"

  identity = {
    name                = "${module.naming.user_assigned_identity.name}-bck"
    location            = "westeurope"
    resource_group_name = module.rg.groups.demo.name
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 6.0"

  postgresql = {
    name                = module.naming.postgresql_server.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    geo_redundant_backup_enabled = true

    administrator_login    = "psqladmin"
    administrator_password = module.kv.secrets.psql-admin-password.value

    identity = {
      type = "UserAssigned"
      identity_ids = [
        module.identity_primary.identity.id,
        module.identity_backup.identity.id
      ]
    }

    customer_managed_key = {
      key_vault_key_id                     = module.kv.keys.psql.id
      primary_user_assigned_identity_id    = module.identity_primary.identity.id
      geo_backup_key_vault_key_id          = module.kv_backup.keys.psql.id
      geo_backup_user_assigned_identity_id = module.identity_backup.identity.id
    }

    role_assignments = {
      primary = {
        scope                = module.kv.vault.id
        role_definition_name = "Key Vault Crypto Officer"
        principal_id         = module.identity_primary.identity.principal_id
      }
      backup = {
        scope                = module.kv_backup.vault.id
        role_definition_name = "Key Vault Crypto Officer"
        principal_id         = module.identity_backup.identity.principal_id
      }
    }
  }
}
