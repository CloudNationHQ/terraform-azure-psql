output "instance" {
  description = "contains all psql flexible server attributes"
  value       = azurerm_postgresql_flexible_server.postgresql
}

output "databases" {
  description = "contains all databases"
  value       = azurerm_postgresql_flexible_server_database.database
}

output "configurations" {
  description = "contains all psql flexible server configurations"
  value       = azurerm_postgresql_flexible_server_configuration.postgresql
}
