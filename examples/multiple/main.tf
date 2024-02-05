module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "northeurope"
    }
  }
}

module "postgresql" {
  #source  = "cloudnationhq/psql/azure"
  #version = "~> 0.1"
  source = "../../"

  naming        = local.naming
  resourcegroup = module.rg.groups.demo.name
  location      = module.rg.groups.demo.location

  for_each = local.instances

  instance = each.value
}
