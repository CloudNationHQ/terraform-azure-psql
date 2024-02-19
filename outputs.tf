output "instance" {
  description = "contains all psql flexible server config"
  value       = azurerm_postgresql_flexible_server.postgresql
}

output "databases" {
  description = "contains all databases"
  value       = azurerm_postgresql_flexible_server_database.database
}
