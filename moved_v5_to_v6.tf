moved {
  from = data.azurerm_client_config.current
  to   = data.azurerm_client_config.this
}

moved {
  from = data.azuread_group.group
  to   = data.azuread_group.this
}

moved {
  from = data.azuread_service_principal.current
  to   = data.azuread_service_principal.this
}

moved {
  from = data.azuread_user.current
  to   = data.azuread_user.this
}

moved {
  from = azurerm_postgresql_flexible_server.postgresql
  to   = azurerm_postgresql_flexible_server.this
}

moved {
  from = azurerm_role_assignment.identity_role_assignment
  to   = azurerm_role_assignment.this
}

moved {
  from = azurerm_postgresql_flexible_server_database.database
  to   = azurerm_postgresql_flexible_server_database.this
}

moved {
  from = azurerm_postgresql_flexible_server_firewall_rule.postgresql
  to   = azurerm_postgresql_flexible_server_firewall_rule.this
}

moved {
  from = azurerm_postgresql_flexible_server_active_directory_administrator.postgresql
  to   = azurerm_postgresql_flexible_server_active_directory_administrator.this
}

moved {
  from = azurerm_postgresql_flexible_server_configuration.postgresql
  to   = azurerm_postgresql_flexible_server_configuration.this
}
