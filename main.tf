data "azurerm_client_config" "current" {}
data "azuread_service_principal" "current" {
  for_each = try(var.instance.ad_admin.principal_name, null) == null ? { "id" = {} } : {}

  object_id = data.azurerm_client_config.current.object_id
}

resource "random_password" "psql_admin_password" {
  length           = 16
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  override_special = "!#$%&-_?"
}

# postgresql server
resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                              = var.instance.name
  resource_group_name               = coalesce(lookup(var.instance, "resource_group", null), var.resourcegroup)
  location                          = coalesce(lookup(var.instance, "location", null), var.location)
  version                           = try(var.instance.server_version, 15)
  sku_name                          = try(var.instance.sku_name, "B_Standard_B1ms")
  storage_mb                        = try(var.instance.storage_mb, 32768)
  backup_retention_days             = try(var.instance.backup_retention_days, null)
  geo_redundant_backup_enabled      = try(var.instance.geo_redundant_backup, false)
  zone                              = try(var.instance.zone, null)
  create_mode                       = try(var.instance.create_mode, "Default")
  administrator_login               = try(var.instance.create_mode, "Default") == "Default" || try(var.instance.enabled.pw_auth, null) == true ? "${replace(var.instance.name, "-", "_")}_admin" : null
  administrator_password            = try(var.instance.create_mode, "Default") == "Default" || try(var.instance.enabled.pw_auth, null) == true ? try(var.instance.admin_password, random_password.psql_admin_password.result) : null
  delegated_subnet_id               = try(var.instance.network.delegated_subnet_id, null)
  private_dns_zone_id               = try(var.instance.network.private_dns_zone_id, null)
  source_server_id                  = try(var.instance.create_mode, null) == "PointInTimeRestore" || try(var.instance.create_mode, null) == "Replica" ? var.instance.source_server_id : null
  point_in_time_restore_time_in_utc = try(var.instance.create_mode, null) == "PointInTimeRestore" ? var.instance.restore_time_utc : null
  replication_role                  = try(var.instance.replication_role, null)

  dynamic "identity" {
    for_each = (try(var.instance.cmk.primary, null) != null || try(var.instance.cmk.backup, null) != null) ? [1] : []

    content {
      type = "UserAssigned"
      identity_ids = compact([
        try(var.instance.cmk.primary, null) != null ? azurerm_user_assigned_identity.identity["primary"].id : "",
        try(var.instance.cmk.backup, null) != null ? azurerm_user_assigned_identity.identity["backup"].id : ""
      ])
    }
  }

  dynamic "customer_managed_key" {
    for_each = (try(var.instance.cmk.primary, null) != null || try(var.instance.cmk.backup, null) != null) ? [1] : []

    content {
      key_vault_key_id                  = try(var.instance.cmk.primary.key_vault_key_id, null)
      primary_user_assigned_identity_id = azurerm_user_assigned_identity.identity["primary"].id

      geo_backup_key_vault_key_id          = try(var.instance.cmk.backup.key_vault_key_id, null)
      geo_backup_user_assigned_identity_id = azurerm_user_assigned_identity.identity["backup"].id
    }
  }

  dynamic "authentication" {
    for_each = try(var.instance.enabled, null) != null ? [1] : []

    content {
      active_directory_auth_enabled = try(var.instance.enabled.ad_auth, true)
      password_auth_enabled         = try(var.instance.enabled.pw_auth, true)
      tenant_id                     = try(var.instance.enabled.ad_auth == true ? data.azurerm_client_config.current.tenant_id : null, null)
    }
  }

  dynamic "high_availability" {
    for_each = try(var.instance.high_availability, null) != null ? [1] : []

    content {
      mode                      = try(var.instance.high_availability.mode, "SameZone")
      standby_availability_zone = try(var.instance.high_availability.standby_availability_zone, null)
    }
  }

  dynamic "maintenance_window" {
    for_each = try(var.instance.maintenance, null) != null ? [1] : []

    content {
      day_of_week  = try(var.instance.maintenance.day_of_week, null)
      start_hour   = try(var.instance.maintenance.start_hour, null)
      start_minute = try(var.instance.maintenance.start_minute, null)
    }
  }

  lifecycle {
    ignore_changes = [zone, high_availability.0.standby_availability_zone]
  }

  depends_on = [azurerm_role_assignment.identity_role_assignment]
}

# user assigned identities
resource "azurerm_user_assigned_identity" "identity" {
  for_each = local.user_assigned_identities

  name                = "uai-${var.instance.name}${each.value != null ? each.value.naming_suffix : ""}"
  resource_group_name = var.instance.resource_group
  location            = var.instance.location
}

resource "azurerm_role_assignment" "identity_role_assignment" {
  for_each = local.role_assignments

  scope                = each.value
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.identity[each.key].principal_id
}

# databases
resource "azurerm_postgresql_flexible_server_database" "database" {
  for_each = try(
    { for database in local.databases : database.db_key => database }, {}
  )

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  charset   = try(each.value.charset, null)
  collation = try(each.value.collation, null)
}

# firewall rules
resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresql" {
  for_each = try(
    { for key_rule, rule in var.instance.fw_rules : key_rule => rule }, {}
  )

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "postgresql" {
  for_each = try(var.instance.enabled.ad_auth, null) == true ? { "ad_auth" = {} } : {}

  server_name         = azurerm_postgresql_flexible_server.postgresql.name
  resource_group_name = var.instance.resource_group
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = try(var.instance.ad_admin.object_id, data.azurerm_client_config.current.object_id)
  principal_type      = try(var.instance.ad_admin.principal_type, "User")
  principal_name      = try(var.instance.ad_admin.principal_name, data.azuread_service_principal.current["id"].display_name)
}
