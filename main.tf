data "azurerm_client_config" "this" {}

data "azuread_group" "this" {
  for_each = {
    for key, admin in var.postgresql.ad_admins :
    key => admin if admin.principal_type == "Group"
  }

  object_id                  = each.value.object_id
  display_name               = each.value.display_name
  mail_nickname              = each.value.mail_nickname
  mail_enabled               = each.value.mail_enabled
  security_enabled           = each.value.security_enabled
  include_transitive_members = each.value.include_transitive_members
}

data "azuread_service_principal" "this" {
  for_each = {
    for key, admin in var.postgresql.ad_admins :
    key => admin if admin.principal_type == "ServicePrincipal"
  }

  display_name = each.value.display_name
  client_id    = each.value.client_id

  object_id = length(compact([each.value.display_name, each.value.client_id])) == 0 ? coalesce(
    each.value.object_id, data.azurerm_client_config.this.object_id
  ) : each.value.object_id
}

data "azuread_user" "this" {
  for_each = {
    for key, admin in var.postgresql.ad_admins :
    key => admin if admin.principal_type == "User"
  }

  user_principal_name = each.value.user_principal_name
  mail                = each.value.mail
  mail_nickname       = each.value.mail_nickname
  employee_id         = each.value.employee_id

  object_id = length(compact([each.value.user_principal_name, each.value.mail, each.value.mail_nickname, each.value.employee_id])) == 0 ? coalesce(
    each.value.object_id, data.azurerm_client_config.this.object_id
  ) : each.value.object_id
}

# postgresql server
resource "azurerm_postgresql_flexible_server" "this" {
  resource_group_name = coalesce(
    var.postgresql.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.postgresql.location, var.location
  )

  name                              = var.postgresql.name
  version                           = var.postgresql.version
  sku_name                          = var.postgresql.sku_name
  storage_mb                        = var.postgresql.storage_mb
  storage_tier                      = var.postgresql.storage_tier
  storage_type                      = var.postgresql.storage_type
  storage_iops                      = var.postgresql.storage_iops
  storage_throughput                = var.postgresql.storage_throughput
  auto_grow_enabled                 = var.postgresql.auto_grow_enabled
  backup_retention_days             = var.postgresql.backup_retention_days
  geo_redundant_backup_enabled      = var.postgresql.geo_redundant_backup_enabled
  zone                              = var.postgresql.zone
  create_mode                       = var.postgresql.create_mode
  administrator_login               = var.postgresql.administrator_login
  administrator_password            = var.postgresql.administrator_password
  administrator_password_wo         = var.postgresql.administrator_password_wo
  administrator_password_wo_version = var.postgresql.administrator_password_wo_version
  delegated_subnet_id               = var.postgresql.delegated_subnet_id
  private_dns_zone_id               = var.postgresql.private_dns_zone_id
  public_network_access_enabled     = var.postgresql.public_network_access_enabled
  replication_role                  = var.postgresql.replication_role
  source_server_id                  = var.postgresql.source_server_id
  point_in_time_restore_time_in_utc = var.postgresql.point_in_time_restore_time_in_utc

  tags = coalesce(
    var.postgresql.tags, var.tags
  )

  dynamic "identity" {
    for_each = var.postgresql.identity != null ? { "this" = var.postgresql.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.postgresql.customer_managed_key != null ? { "this" = var.postgresql.customer_managed_key } : {}

    content {
      key_vault_key_id                     = customer_managed_key.value.key_vault_key_id
      geo_backup_key_vault_key_id          = customer_managed_key.value.geo_backup_key_vault_key_id
      primary_user_assigned_identity_id    = customer_managed_key.value.primary_user_assigned_identity_id
      geo_backup_user_assigned_identity_id = customer_managed_key.value.geo_backup_user_assigned_identity_id
    }
  }

  authentication {
    active_directory_auth_enabled = var.postgresql.authentication.active_directory_auth_enabled
    password_auth_enabled         = var.postgresql.authentication.password_auth_enabled
    tenant_id                     = var.postgresql.authentication.active_directory_auth_enabled ? data.azurerm_client_config.this.tenant_id : null
  }

  dynamic "high_availability" {
    for_each = var.postgresql.high_availability != null ? { "this" = var.postgresql.high_availability } : {}

    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.postgresql.maintenance_window != null ? { "this" = var.postgresql.maintenance_window } : {}

    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  dynamic "cluster" {
    for_each = var.postgresql.cluster != null ? { "this" = var.postgresql.cluster } : {}

    content {
      size                  = cluster.value.size
      default_database_name = cluster.value.default_database_name
    }
  }

  lifecycle {
    ignore_changes = [zone, high_availability[0].standby_availability_zone]
  }
  depends_on = [azurerm_role_assignment.this]
}

resource "azurerm_role_assignment" "this" {
  for_each = var.postgresql.role_assignments

  name                                   = each.value.name
  scope                                  = each.value.scope
  principal_id                           = each.value.principal_id
  role_definition_name                   = each.value.role_definition_name
  role_definition_id                     = each.value.role_definition_id
  description                            = each.value.description
  principal_type                         = each.value.principal_type
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

# databases
resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each = var.postgresql.databases

  name = coalesce(
    each.value.name, each.key
  )

  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = each.value.charset
  collation = each.value.collation
}

# firewall rules
resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each = var.postgresql.fw_rules

  name = coalesce(
    each.value.name, each.key
  )

  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "this" {
  for_each = var.postgresql.ad_admins

  resource_group_name = coalesce(
    var.postgresql.resource_group_name, var.resource_group_name
  )

  server_name    = azurerm_postgresql_flexible_server.this.name
  tenant_id      = data.azurerm_client_config.this.tenant_id
  principal_type = each.value.principal_type

  object_id = try(
    data.azuread_group.this[each.key].object_id,
    data.azuread_user.this[each.key].object_id,
    data.azuread_service_principal.this[each.key].object_id
  )

  principal_name = coalesce(
    each.value.principal_name,
    try(
      data.azuread_group.this[each.key].display_name,
      data.azuread_user.this[each.key].display_name,
      data.azuread_service_principal.this[each.key].display_name
    )
  )
}

resource "azurerm_postgresql_flexible_server_configuration" "this" {
  for_each = var.postgresql.configurations

  name      = coalesce(each.value.name, each.key)
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = each.value.value
}
