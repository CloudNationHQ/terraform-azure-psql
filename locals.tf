locals {
  role_assignments = try(var.instance.cmk != null, false) ? {
    primary = var.instance.cmk.primary.key_vault_id
    try(var.instance.cmk.backup.key_vault_id, null) != null ? backup = var.instance.cmk.backup.key_vault_id : null
  } : {}
}

locals {
  user_assigned_identities = try(var.instance.cmk != null, false) ? {
    primary = var.instance.cmk.primary != null ? { naming_suffix = "" } : null,
    backup  = try(var.instance.cmk.backup, null) != null ? { naming_suffix = "-bck" } : null
  } : {}
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
