# Postgresql Flexible Server

This Terraform module streamlines the creation and management of postgresql flexible servers on Azure, offering a flexible solution for deploying optimized instances.

## Features

- enables azure ad and local administrator authentication, individually or in combination.
- provides support for customer managed keys using an existing user-assigned identity.
- facilitates vnet integration through subnet delegation and private DNS zones.
- offers maintenance, high availability, options for robust management.
- allows creation of empty databases.
- utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.13)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) (resource)
- [azurerm_postgresql_flexible_server_active_directory_administrator.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) (resource)
- [azurerm_postgresql_flexible_server_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) (resource)
- [azurerm_postgresql_flexible_server_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) (resource)
- [azurerm_postgresql_flexible_server_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_user.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_postgresql"></a> [postgresql](#input\_postgresql)

Description: describes psql server related configuration

Type:

```hcl
object({
    name                              = string
    resource_group_name               = optional(string)
    location                          = optional(string)
    version                           = optional(number, 16)
    sku_name                          = optional(string, "B_Standard_B1ms")
    storage_mb                        = optional(number)
    storage_tier                      = optional(string)
    storage_type                      = optional(string)
    storage_iops                      = optional(number)
    storage_throughput                = optional(number)
    auto_grow_enabled                 = optional(bool)
    backup_retention_days             = optional(number)
    geo_redundant_backup_enabled      = optional(bool)
    zone                              = optional(string)
    create_mode                       = optional(string, "Default")
    administrator_login               = optional(string)
    administrator_password            = optional(string)
    administrator_password_wo         = optional(string)
    administrator_password_wo_version = optional(number)
    delegated_subnet_id               = optional(string)
    private_dns_zone_id               = optional(string)
    public_network_access_enabled     = optional(bool)
    source_server_id                  = optional(string)
    point_in_time_restore_time_in_utc = optional(string)
    replication_role                  = optional(string)
    tags                              = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    customer_managed_key = optional(object({
      key_vault_key_id                     = optional(string)
      geo_backup_key_vault_key_id          = optional(string)
      primary_user_assigned_identity_id    = optional(string)
      geo_backup_user_assigned_identity_id = optional(string)
    }))
    authentication = optional(object({
      active_directory_auth_enabled = optional(bool, false)
      password_auth_enabled         = optional(bool, true)
    }), {})
    high_availability = optional(object({
      mode                      = optional(string)
      standby_availability_zone = optional(string)
    }))
    maintenance_window = optional(object({
      day_of_week  = optional(number)
      start_hour   = optional(number)
      start_minute = optional(number)
    }))
    cluster = optional(object({
      size                  = number
      default_database_name = optional(string)
    }))
    databases = optional(map(object({
      name      = optional(string)
      charset   = optional(string)
      collation = optional(string)
    })), {})
    fw_rules = optional(map(object({
      name             = optional(string)
      start_ip_address = string
      end_ip_address   = string
    })), {})
    ad_admins = optional(map(object({
      principal_type             = optional(string, "ServicePrincipal")
      principal_name             = optional(string)
      object_id                  = optional(string)
      display_name               = optional(string)
      client_id                  = optional(string)
      user_principal_name        = optional(string)
      mail                       = optional(string)
      mail_nickname              = optional(string)
      employee_id                = optional(string)
      mail_enabled               = optional(bool)
      security_enabled           = optional(bool)
      include_transitive_members = optional(bool)
    })), {})
    configurations = optional(map(object({
      name  = optional(string)
      value = string
    })), {})
    role_assignments = optional(map(object({
      scope                                  = string
      principal_id                           = string
      name                                   = optional(string)
      role_definition_name                   = optional(string)
      role_definition_id                     = optional(string)
      description                            = optional(string)
      principal_type                         = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      skip_service_principal_aad_check       = optional(bool)
    })), {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group and can be used if resourcegroup is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_configurations"></a> [configurations](#output\_configurations)

Description: contains all psql flexible server configurations

### <a name="output_databases"></a> [databases](#output\_databases)

Description: contains all databases

### <a name="output_server"></a> [server](#output\_server)

Description: contains all psql flexible server attributes
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/postgresql/)
