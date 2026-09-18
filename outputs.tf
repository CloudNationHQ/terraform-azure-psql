output "server" {
  description = "contains all psql flexible server attributes"
  value       = azurerm_postgresql_flexible_server.this
}

output "databases" {
  description = "contains all databases"
  value       = azurerm_postgresql_flexible_server_database.this
}

output "configurations" {
  description = "contains all psql flexible server configurations"
  value       = azurerm_postgresql_flexible_server_configuration.this
}
