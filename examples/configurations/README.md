This example illustrates configuring multiple databases.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string

  configurations = optional(map(object({
    name  = string
    value = string
  })))
})
```
