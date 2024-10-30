This example illustrates the most complete postgresql flexible server setup. 

## Types

```hcl
instance = object({
  name                          = string
  location                      = string
  resource_group                = string
  version                       = optional(number, 16)
  sku_name                      = optional(string, "B_Standard_B1ms")
  storage_mb                    = optional(number, 32768)
  backup_retention_days         = optional(number)
  geo_redundant_backup_enabled  = optional(bool, false)
  zone                          = optional(number)
  create_mode                   = optional(string, "Default")
  public_network_access_enabled = optional(bool, true)

  administrator_password        = optional(string)
  administrator_login           = optional(string, "${instance.name}_admin")

  create_mode      = optional(string, "Default")
  source_server_id = optional(string) ## Only needed if PointInTimeRestore or Replica

  point_in_time_restore_time_in_utc = optional(string) ## Only needed if PointInTimeRestore

  delegated_subnet_id = optional(string)
  private_dns_zone_id = optional(string)

  customer_managed_key = optional(object({
    primary = object({
      key_vault_id     = string
      key_vault_key_id = string
    })
    backup = optional(object({
      key_vault_id     = string
      key_vault_key_id = string
    }))
  }))

  databases = optional(map(object({
    charset   = optional(string, "UTF8")
    collation = optional(string)
  })))

  firewall_rules = optional(map(object({
    start_ip_address = string
    end_ip_address   = string
  })))

  authentication = optional(object({
    active_directory_auth_enabled = bool
    password_auth_enabled         = bool
    tenant_id                     = optional(string)
  }))

  ad_admin = optional(object({
    principal_type = optional(string, "ServicePrincipal")
    object_id      = optional(string)
    principal_name = optional(string)
  }))

  maintenance_window = optional(object({
    day_of_week  = optional(string)
    start_hour   = optional(string)
    start_minute = optional(string)
  }))

  high_availability = optional(object({
    mode                      = optional(string, "SameZone")
    standby_availability_zone = number
  }))
})
```
