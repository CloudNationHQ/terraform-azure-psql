This section focuses on high availability configuration.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 1.0"

  instance = {
    name           = module.naming.postgresql_server.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku_name       = "GP_Standard_D4ads_v5"
    zone           = 1

    high_availability = {
      mode                      = "ZoneRedundant"
      standby_availability_zone = 3
    }
  }
}
```
