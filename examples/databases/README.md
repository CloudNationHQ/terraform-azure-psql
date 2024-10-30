This example illustrates configuring multiple databases.

## Types

```hcl
instance = object({
  name           = string
  location       = string
  resource_group = string

  databases = optional(map(object({
    name      = optional(string) #if not provided, it will be derived from the key
    charset   = optional(string, "UTF8")
    collation = optional(string)
  })))
})
```
