output "postgresql_server" {
  description = "contains the postgresql server config"
  value       = azurerm_postgresql_flexible_server.postgresql
}

output "databases" {
  description = "contains the databases created on the postgresql server"
  value       = azurerm_postgresql_flexible_server_database.database
}
