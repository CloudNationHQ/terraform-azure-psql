module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "northeurope"
    }
  }
}

module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 5.0"

  instance = {
    name                = module.naming.postgresql_server.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    authentication = {
      active_directory_auth_enabled = true
      password_auth_enabled         = true
    }

    ad_admins = {
      user-dba = {
        # Defaults to the identity running Terraform. Set principal_type = "User"
        # when authenticating with a personal account instead of a service principal.
        principal_type = "ServicePrincipal"
      }
      group-infra = {
        principal_type = "Group"
        principal_name = "infra-admin"
      }
    }
  }
}
