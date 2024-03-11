locals {
  postgresql_servers = {
    main = {
      name           = "${module.naming.postgresql_server.name}-main"
      location       = module.rg.groups.demo.location
      resource_group = module.rg.groups.demo.name

      server_version               = 15
      sku_name                     = "GP_Standard_D2s_v3"
      storage_mb                   = 65536
      backup_retention_days        = 35
      geo_redundant_backup_enabled = true
      zone                         = 1
      create_mode                  = "Default"

      admin_password = module.kv["main"].secrets.psql-admin-password.value

      cmk = {
        primary = {
          key_vault_id     = module.kv["main"].vault.id
          key_vault_key_id = module.kv["main"].keys.psql.id
        }
        backup = {
          key_vault_id     = module.kv["backup"].vault.id
          key_vault_key_id = module.kv["backup"].keys.psql.id
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

      network = {
        delegated_subnet_id = module.network.subnets.psql.id
        private_dns_zone_id = module.private_dns.zone.id
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
  }
  postgresql_replicas = {
    replica = {
      name                  = "${module.naming.postgresql_server.name}-replica"
      location              = module.rg.groups.demo.location
      resource_group        = module.rg.groups.demo.name
      server_version        = 15
      sku_name              = "GP_Standard_D2s_v3"
      storage_mb            = 65536
      backup_retention_days = 35
      zone                  = 1

      create_mode      = "Replica"
      source_server_id = module.postgresql["main"].instance.id

      admin_password      = module.kv["main"].secrets.psql-admin-password.value
      key_vault_id        = module.kv["main"].vault.id
      key_vault_backup_id = module.kv["backup"].vault.id

      cmk = {
        primary = {
          key_vault_id     = module.kv["main"].vault.id
          key_vault_key_id = module.kv["main"].keys.psql.id
        }
        backup = {
          key_vault_id     = module.kv["backup"].vault.id
          key_vault_key_id = module.kv["backup"].keys.psql.id
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
        private_dns_zone_id = module.private_dns.zone.id
      }
    }
    restore = {
      name           = "${module.naming.postgresql_server.name}-restore"
      location       = module.rg.groups.demo.location
      resource_group = module.rg.groups.demo.name

      server_version        = 15
      sku_name              = "GP_Standard_D2s_v3"
      storage_mb            = 65536
      backup_retention_days = 35

      create_mode      = "PointInTimeRestore"
      source_server_id = module.postgresql["main"].instance.id
      restore_time_utc = timeadd(timestamp(), "30m")
    }
  }
}
