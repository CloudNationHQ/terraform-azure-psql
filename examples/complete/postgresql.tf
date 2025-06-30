locals {
  postgresql_server = {
    name                = module.naming.postgresql_server.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    version                       = 15
    sku_name                      = "GP_Standard_D2s_v3"
    storage_mb                    = 65536
    backup_retention_days         = 35
    geo_redundant_backup_enabled  = true
    zone                          = 1
    create_mode                   = "Default"
    public_network_access_enabled = false

    administrator_password = module.kv.main.secrets.psql-admin-password.value

    customer_managed_key = {
      primary = {
        key_vault_id     = module.kv.main.vault.id
        key_vault_key_id = module.kv.main.keys.psql.id
      }
      backup = {
        key_vault_id     = module.kv.backup.vault.id
        key_vault_key_id = module.kv.backup.keys.psql.id
      }
    }

    databases = {
      postgresdb1 = {
        charset = "UTF8"
      }
      postgresdb2 = {
      }
    }

    firewall_rules = {
      rule1 = {
        start_ip_address = "255.255.255.255"
        end_ip_address   = "255.255.255.255"
      }
      AllowAzureServices = {
        start_ip_address = "0.0.0.0"
        end_ip_address   = "0.0.0.0"
      }
    }

    authentication = {
      active_directory_auth_enabled = true
      password_auth_enabled         = true
    }

    ad_admins = {
      user-dba = {
        # Specifies the AD admin as a Service Principal or User, defaults to ServicePrincipal in the current Terraform run.
        # Set principal_type = "User" when running Terraform using a personal account.
        principal_type = "User"

        # Optional: Specify another AD admin (user or service principal).
        # object_id      = "6cecf2ab-c0ef-4047-9221-479c074d6a45"
        # principal_name = "john.doe@sometenant.onmicrosoft.com"
      }
    }

    network = {
      delegated_subnet_id = module.network.subnets.psql.id
      private_dns_zone_id = module.private_dns.private_zones.psql.id
    }

    maintenance_window = {
      day_of_week  = "0" #sunday
      start_hour   = "20"
      start_minute = "30"
    }

    high_availability = {
      mode                      = "ZoneRedundant"
      standby_availability_zone = 2
    }
  }
  postgresql_replicas = {
    replica = {
      name                          = "${module.naming.postgresql_server.name}-replica"
      location                      = module.rg.groups.demo.location
      resource_group_name           = module.rg.groups.demo.name
      version                       = 15
      sku_name                      = "GP_Standard_D2s_v3"
      storage_mb                    = 65536
      backup_retention_days         = 35
      zone                          = 1
      public_network_access_enabled = false

      create_mode      = "Replica"
      source_server_id = module.postgresql.server.id

      administrator_password = module.kv.main.secrets.psql-admin-password.value

      customer_managed_key = {
        primary = {
          key_vault_id     = module.kv.main.vault.id
          key_vault_key_id = module.kv.main.keys.psql.id
        }
        backup = {
          key_vault_id     = module.kv.backup.vault.id
          key_vault_key_id = module.kv.backup.keys.psql.id
        }
      }

      firewall_rules = {
        rule1 = {
          start_ip_address = "255.255.255.255"
          end_ip_address   = "255.255.255.255"
        }
        AllowAzureServices = {
          start_ip_address = "0.0.0.0"
          end_ip_address   = "0.0.0.0"
        }
      }

      network = {
        delegated_subnet_id = module.network.subnets.psql.id
        private_dns_zone_id = module.private_dns.private_zones.psql.id
      }
    }
    restore = {
      name                = "${module.naming.postgresql_server.name}-restore"
      location            = module.rg.groups.demo.location
      resource_group_name = module.rg.groups.demo.name

      version               = 15
      sku_name              = "GP_Standard_D2s_v3"
      storage_mb            = 65536
      backup_retention_days = 35

      create_mode                       = "PointInTimeRestore"
      source_server_id                  = module.postgresql.server.id
      point_in_time_restore_time_in_utc = timeadd(timestamp(), "30m")
    }
  }
}
