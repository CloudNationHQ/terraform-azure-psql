variable "postgresql" {
  description = "describes psql server related configuration"
  type = object({
    name                              = string
    resource_group_name               = optional(string)
    location                          = optional(string)
    version                           = optional(number, 16)
    sku_name                          = optional(string, "B_Standard_B1ms")
    storage_mb                        = optional(number)
    storage_tier                      = optional(string)
    storage_type                      = optional(string)
    storage_iops                      = optional(number)
    storage_throughput                = optional(number)
    auto_grow_enabled                 = optional(bool)
    backup_retention_days             = optional(number)
    geo_redundant_backup_enabled      = optional(bool)
    zone                              = optional(string)
    create_mode                       = optional(string, "Default")
    administrator_login               = optional(string)
    administrator_password            = optional(string)
    administrator_password_wo         = optional(string)
    administrator_password_wo_version = optional(number)
    delegated_subnet_id               = optional(string)
    private_dns_zone_id               = optional(string)
    public_network_access_enabled     = optional(bool)
    source_server_id                  = optional(string)
    point_in_time_restore_time_in_utc = optional(string)
    replication_role                  = optional(string)
    tags                              = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    customer_managed_key = optional(object({
      key_vault_key_id                     = optional(string)
      geo_backup_key_vault_key_id          = optional(string)
      primary_user_assigned_identity_id    = optional(string)
      geo_backup_user_assigned_identity_id = optional(string)
    }))
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
    }), {})
    high_availability = optional(object({
      mode                      = optional(string)
      standby_availability_zone = optional(string)
    }))
    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }))
    cluster = optional(object({
      size                  = number
      default_database_name = optional(string)
    }))
    databases = optional(map(object({
      name      = optional(string)
      charset   = optional(string)
      collation = optional(string)
    })), {})
    fw_rules = optional(map(object({
      name             = optional(string)
      start_ip_address = string
      end_ip_address   = string
    })), {})
    ad_admins = optional(map(object({
      principal_type             = optional(string, "ServicePrincipal")
      principal_name             = optional(string)
      object_id                  = optional(string)
      display_name               = optional(string)
      client_id                  = optional(string)
      user_principal_name        = optional(string)
      mail                       = optional(string)
      mail_nickname              = optional(string)
      employee_id                = optional(string)
      mail_enabled               = optional(bool)
      security_enabled           = optional(bool)
      include_transitive_members = optional(bool)
    })), {})
    configurations = optional(map(object({
      name  = optional(string)
      value = string
    })), {})
    role_assignments = optional(map(object({
      scope                                  = string
      principal_id                           = string
      name                                   = optional(string)
      role_definition_name                   = optional(string)
      role_definition_id                     = optional(string)
      description                            = optional(string)
      principal_type                         = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })), {})
  })

  validation {
    condition     = var.postgresql.resource_group_name != null || var.resource_group_name != null
    error_message = "resource_group must be provided either in the postgresql object or as a separate variable."
  }

  validation {
    condition     = var.postgresql.location != null || var.location != null
    error_message = "location must be provided either in the postgresql object or as a separate variable."
  }
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
