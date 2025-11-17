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
    delegated_subnet_id               = optional(string)
    private_dns_zone_id               = optional(string)
    public_network_access_enabled     = optional(bool, true)
    source_server_id                  = optional(string)
    point_in_time_restore_time_in_utc = optional(string)
    replication_role                  = optional(string)
    tags                              = optional(map(string))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id                     = string
      geo_backup_key_vault_key_id          = optional(string)
      primary_user_assigned_identity_id    = string
      geo_backup_user_assigned_identity_id = optional(string)
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

  validation {
    condition     = var.instance.storage_mb == null || contains(["32768","65536","131072","262144","524288","1048576","2097152","4193280","4194304","8388608","16777216","33553408"], var.instance.storage_mb)
    error_message = "storage_mb must be one of: 32768,65536,131072,262144,524288,1048576,2097152,4193280,4194304,8388608,16777216,33553408."
  }

  validation {
    condition     = var.instance.storage_tier == null || contains(["P4","P6","P10","P15","P20","P30","P40","P50","P60","P70","P80"], var.instance.storage_tier)
    error_message = "storage_tier must be one of: P4,P6,P10,P15,P20,P30,P40,P50,P60,P70,P80."
  }

  validation {
    condition = var.instance.high_availability.mode == null || contains(["ZoneRedundant","SameZone"], var.instance.high_availability.mode)
    error_message = "high_availability.mode must be ZoneRedundant or SameZone."
  }

  validation {
    condition = var.instance.identity == null || var.instance.identity.type == "UserAssigned"
    error_message = "identity.type must be UserAssigned."
  }

  validation {
    condition = var.instance.customer_managed_key == null || (
      var.instance.customer_managed_key.key_vault_key_id != "" &&
      var.instance.customer_managed_key.primary_user_assigned_identity_id != ""
    )
    error_message = "customer_managed_key requires key_vault_key_id and primary_user_assigned_identity_id."
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