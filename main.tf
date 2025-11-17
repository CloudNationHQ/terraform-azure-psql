data "azurerm_client_config" "current" {}

data "azuread_group" "group" {
  for_each = { for admin_key, admin in var.instance.ad_admins : admin_key => admin if admin.principal_type == "Group" && admin.object_id == null }

  display_name = each.value.principal_name
}

data "azuread_service_principal" "current" {
  for_each = length([for admin_key, admin in var.instance.ad_admins : admin_key if admin.principal_type == "ServicePrincipal" && admin.object_id == null]) > 0 ? { "default" = {} } : {}

  object_id = data.azurerm_client_config.current.object_id
}

data "azuread_user" "current" {
  for_each = length([for admin_key, admin in var.instance.ad_admins : admin_key if admin.principal_type == "User" && admin.object_id == null]) > 0 ? { "default" = {} } : {}

  object_id = data.azurerm_client_config.current.object_id
}

# postgresql server
resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                              = var.instance.name
  resource_group_name               = coalesce(var.instance.resource_group_name, var.resource_group_name)
  location                          = coalesce(var.instance.location, var.location)
  version                           = var.instance.version
  sku_name                          = var.instance.sku_name
  storage_mb                        = var.instance.storage_mb
  storage_tier                      = var.instance.storage_tier
  auto_grow_enabled                 = var.instance.auto_grow_enabled
  backup_retention_days             = var.instance.backup_retention_days
  geo_redundant_backup_enabled      = var.instance.geo_redundant_backup_enabled
  zone                              = var.instance.zone
  create_mode                       = var.instance.create_mode
  administrator_login               = var.instance.administrator_login
  administrator_password            = var.instance.administrator_password
  delegated_subnet_id               = var.instance.delegated_subnet_id
  private_dns_zone_id               = var.instance.private_dns_zone_id
  public_network_access_enabled     = var.instance.public_network_access_enabled
  source_server_id                  = var.instance.source_server_id
  point_in_time_restore_time_in_utc = var.instance.point_in_time_restore_time_in_utc
  replication_role                  = var.instance.replication_role

  tags = coalesce(
    var.instance.tags, var.tags
  )

  dynamic "identity" {
    for_each = lookup(var.instance, "identity", null) != null ? [var.instance.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = try(var.instance.customer_managed_key, null) != null ? { "default" = var.instance.customer_managed_key } : {}

    content {
      key_vault_key_id                     = customer_managed_key.value.key_vault_key_id
      geo_backup_key_vault_key_id          = customer_managed_key.value.geo_backup_key_vault_key_id
      primary_user_assigned_identity_id    = customer_managed_key.value.primary_user_assigned_identity_id
      geo_backup_user_assigned_identity_id = customer_managed_key.value.geo_backup_user_assigned_identity_id
    }
  }

  authentication {
    active_directory_auth_enabled = var.instance.authentication.active_directory_auth_enabled
    password_auth_enabled         = var.instance.authentication.password_auth_enabled
    tenant_id                     = var.instance.authentication.active_directory_auth_enabled == true ? data.azurerm_client_config.current.tenant_id : null
  }

  dynamic "high_availability" {
    for_each = var.instance.high_availability.mode != null ? [1] : []

    content {
      mode                      = var.instance.high_availability.mode
      standby_availability_zone = var.instance.high_availability.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = (var.instance.maintenance_window.day_of_week != null || var.instance.maintenance_window.start_hour != null || var.instance.maintenance_window.start_minute != null) ? [1] : []

    content {
      day_of_week  = var.instance.maintenance_window.day_of_week
      start_hour   = var.instance.maintenance_window.start_hour
      start_minute = var.instance.maintenance_window.start_minute
    }
  }

  lifecycle {
    ignore_changes = [zone, high_availability[0].standby_availability_zone]
  }

  depends_on = [azurerm_role_assignment.identity_role_assignment]
}

# databases
resource "azurerm_postgresql_flexible_server_database" "database" {
  for_each = lookup(var.instance, "databases", null) != null ? var.instance.databases : {}

  name = coalesce(
    each.value.name, join("-", [var.naming.mysql_database, each.key])
  )

  server_id = azurerm_postgresql_flexible_server.postgresql.id
  collation   = each.value.collation
  charset     = each.value.charset
}

# firewall rules
resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresql" {
  for_each = var.instance.fw_rules

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "postgresql" {
  for_each = var.instance.authentication.active_directory_auth_enabled == true ? var.instance.ad_admins : {}

  server_name         = azurerm_postgresql_flexible_server.postgresql.name
  resource_group_name = coalesce(var.instance.resource_group_name, var.resource_group_name)
  tenant_id           = data.azurerm_client_config.current.tenant_id

  object_id = each.value.object_id != null ? each.value.object_id : (
    each.value.principal_type == "Group" ? data.azuread_group.group[each.key].object_id : data.azurerm_client_config.current.object_id
  )

  principal_type = each.value.principal_type
  principal_name = coalesce(
    each.value.principal_name,
    each.value.principal_type == "User" && each.value.object_id == null && length(data.azuread_user.current) > 0 ? data.azuread_user.current["default"].display_name : null,
    each.value.principal_type == "ServicePrincipal" && each.value.object_id == null && length(data.azuread_service_principal.current) > 0 ? data.azuread_service_principal.current["default"].display_name : null,
    "Unknown"
  )
}

resource "azurerm_postgresql_flexible_server_configuration" "postgresql" {
  for_each = var.instance.configurations

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  value     = each.value.value
}
