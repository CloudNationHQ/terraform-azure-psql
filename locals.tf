locals {
  user_assigned_identities = flatten([for uai_key, uai in lookup(var.instance, "customer_managed_key", {}) :
    {
      key              = uai_key
      naming_suffix    = uai_key == "backup" ? "-bck" : ""
      key_vault_id     = uai.key_vault_id
      key_vault_key_id = uai.key_vault_key_id
    } if lookup(var.instance, "customer_managed_key", null) != null
  ])
}

locals {
  databases = flatten([
    for db_key, db in try(var.instance.databases, {}) : {

      db_key    = db_key
      name      = try(db.name, join("-", [var.naming.postgresql_database, db_key]))
      charset   = try(db.charset, null)
      collation = try(db.collation, null)
    }
  ])
}
