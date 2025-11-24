variable "instance" {
  description = "describes psql server related configuration"
  type = object({
    name                              = string
    resource_group_name               = optional(string)
    location                          = optional(string)
    version                           = optional(number, 16)
    sku_name                          = optional(string, "B_Standard_B1ms")
    storage_mb                        = optional(number, 32768)
    storage_tier                      = optional(string)
    auto_grow_enabled                 = optional(bool, false)
    backup_retention_days             = optional(number)
    geo_redundant_backup_enabled      = optional(bool, false)
    zone                              = optional(string)
    create_mode                       = optional(string, "Default")
    administrator_login               = optional(string)
    administrator_password            = optional(string)
    administrator_password_wo         = optional(string)
    administrator_password_wo_version = optional(number)
    delegated_subnet_id               = optional(string)
    private_dns_zone_id               = optional(string)
    public_network_access_enabled     = optional(bool, true)
    source_server_id                  = optional(string)
    point_in_time_restore_time_in_utc = optional(string)
    replication_role                  = optional(string)
    tags                              = optional(map(string))

    customer_managed_key = optional(object({
      primary = optional(object({
        key_vault_id     = string
        key_vault_key_id = string
      }))
      backup = optional(object({
        key_vault_id     = string
        key_vault_key_id = string
      }))
    }))

    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
    }), {})

    high_availability = optional(object({
      mode                      = optional(string)
      standby_availability_zone = optional(string)
    }), {})

    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }), {})

    databases = optional(map(object({
      name      = optional(string)
      charset   = optional(string)
      collation = optional(string)
    })), {})

    fw_rules = optional(map(object({
      start_ip_address = string
      end_ip_address   = string
    })), {})

    ad_admins = optional(map(object({
      object_id      = optional(string)
      principal_type = optional(string, "ServicePrincipal")
      principal_name = optional(string)
    })), {})

    configurations = optional(map(object({
      name  = string
      value = string
    })), {})
  })

  validation {
    condition     = var.instance.resource_group_name != null || var.resource_group_name != null
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

variable "resource_group_name" {
  description = "default resource group and can be used if resourcegroup is not specified inside the object."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
