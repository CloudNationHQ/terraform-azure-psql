This example illustrates configuring multiple databases.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 1.0"

  naming = local.naming

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    databases = {
      user  = { charset = "UTF8" }
      order = {}
    }
  }
}
```
