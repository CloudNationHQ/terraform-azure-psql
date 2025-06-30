variable "instance" {
  description = "describes psql server related configuration"
  type = object({
    name                              = string
    resource_group                    = optional(string, null)
    location                          = optional(string, null)
    version                           = optional(number, 16)
    sku_name                          = optional(string, "B_Standard_B1ms")
    storage_mb                        = optional(number, 32768)
    backup_retention_days             = optional(number, null)
    geo_redundant_backup_enabled      = optional(bool, false)
    zone                              = optional(string, null)
    create_mode                       = optional(string, "Default")
    administrator_login               = optional(string, null)
    administrator_password            = optional(string, null)
    delegated_subnet_id               = optional(string, null)
    private_dns_zone_id               = optional(string, null)
    public_network_access_enabled     = optional(bool, true)
    source_server_id                  = optional(string, null)
    point_in_time_restore_time_in_utc = optional(string, null)
    replication_role                  = optional(string, null)

    customer_managed_key = optional(object({
      primary = optional(object({
        key_vault_id     = string
        key_vault_key_id = string
      }), null)
      backup = optional(object({
        key_vault_id     = string
        key_vault_key_id = string
      }), null)
    }), null) # Keep as null since it's truly optional and complex to handle

    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
    }), {}) # Changed from null to {} - enables removing try() functions

    high_availability = optional(object({
      mode                      = optional(string, "SameZone")
      standby_availability_zone = optional(string, null)
    }), {}) # Changed from null to {} - enables removing try() functions

    maintenance_window = optional(object({
      day_of_week  = optional(number, null)
      start_hour   = optional(number, null)
      start_minute = optional(number, null)
    }), {}) # Changed from null to {} - enables removing try() functions

    databases = optional(map(object({
      name      = optional(string)
      charset   = optional(string, null)
      collation = optional(string, null)
    })), {})

    fw_rules = optional(map(object({
      start_ip_address = string
      end_ip_address   = string
    })), {})

    ad_admins = optional(map(object({
      object_id      = optional(string, null)
      principal_type = optional(string, "ServicePrincipal")
      principal_name = optional(string, null)
    })), {})

    configurations = optional(map(object({
      name  = string
      value = string
    })), {})
  })

  validation {
    condition     = var.instance.resource_group != null || var.resource_group != null
    error_message = "resource_group must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.location != null || var.location != null
    error_message = "location must be provided either in the instance object or as a separate variable."
  }

  validation {
    condition     = var.instance.create_mode == null || contains(["Default", "PointInTimeRestore", "Replica"], var.instance.create_mode)
    error_message = "create_mode must be one of: Default, PointInTimeRestore, Replica."
  }

  validation {
    condition     = var.instance.create_mode != "PointInTimeRestore" || var.instance.point_in_time_restore_time_in_utc != null
    error_message = "point_in_time_restore_time_in_utc is required when create_mode is PointInTimeRestore."
  }

  validation {
    condition     = (var.instance.create_mode != "PointInTimeRestore" && var.instance.create_mode != "Replica") || var.instance.source_server_id != null
    error_message = "source_server_id is required when create_mode is PointInTimeRestore or Replica."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region and can be used if location is not specified inside the object."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}
