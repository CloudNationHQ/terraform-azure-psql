locals {
  identities = {
    primary = {
      name           = module.naming.user_assigned_identity.name
      location       = module.rg.groups.demo.location
      resource_group = module.rg.groups.demo.name
    }
    backup = {
      name           = "${module.naming.user_assigned_identity.name}-backup"
      location       = module.rg.groups.demo.location
      resource_group = module.rg.groups.demo.name
    }
  }
}