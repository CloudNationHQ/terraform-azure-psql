This example highlights configuring replicas.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string
  sku_name       = string

  create_mode      = string
  source_server_id = string
})
```
