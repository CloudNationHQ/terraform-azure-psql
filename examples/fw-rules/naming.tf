locals {
  naming = {
    postgresql_database = module.naming.postgresql_database.name
  }
}
