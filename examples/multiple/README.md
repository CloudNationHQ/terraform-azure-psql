This example demonstrates the use of both configuration and resource based outputs when deploying multiple instances.

## Usage:

```hcl
module "postgresql" {
  source = "cloudnationhq/psql/azure"
  version = "~> 0.5"

  for_each = local.psql

  naming = local.naming
  instance = each.value
}
```

The local variable defined below holds all our config.

```hcl
locals {
  instances = {
    inst1 = {
      name = "psql-demo-dev-1"
      databases = {
        user = { charset = "UTF8" }
      }
    }
    inst2 = {
      name = "psql-demo-dev-2"
      fw_rules = {
        sales = {
          start_ip_address = "10.20.30.1"
          end_ip_address   = "10.20.30.255"
        }
      }
    }
  }
}
```

The below configuration based output shows how to retrieve values from this local variable.

```hcl
output "instances" {
  value = {
    for cl_name, cl_config in local.clusters : cl_name => {
      name       = cl_config.name
      dns_prefix = cl_config.dns_prefix
    }
  }
}
```

From other modules this can be referenced like `module.aks.clusters.cl1.name` or `module.aks.clusters.cl2.name`

The below resource level based output can be used for example to get the cluster ids.

```hcl
output "clusters" {
  value = {
    for k, module_instance in module.aks : k => module_instance.cluster
  }
}
```

Now this can be referenced using `module.aks.clusters.cl1.id`

