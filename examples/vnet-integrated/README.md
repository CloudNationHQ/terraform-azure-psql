This section outlines vnet integration for improved database connectivity.

## Usage

```hcl
module "postgresql" {
  source  = "cloudnationhq/psql/azure"
  version = "~> 0.7"

  instance = {
    name                          = module.naming.postgresql_server.name_unique
    location                      = module.rg.groups.demo.location
    resource_group                = module.rg.groups.demo.name
    public_network_access_enabled = false

    network = {
      delegated_subnet_id = module.network.subnets.postgresql.id
      private_dns_zone_id = module.private_dns.zone.id
    }
  }
}
```
