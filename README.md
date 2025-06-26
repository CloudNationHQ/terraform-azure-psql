# Postgresql Flexible Server

This Terraform module streamlines the creation and management of postgresql flexible servers on Azure, offering a flexible solution for deploying optimized instances.

**Note**: This module will deploy the flexible server and not the single server which is on a deprecation [path](https://azure.microsoft.com/en-us/updates/azure-database-for-postgresql-single-server-will-be-retired-migrate-to-flexible-server-by-28-march-2025/).

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

## Features

- enables azure ad and local administrator authentication, individually or in combination.
- provides support for customer managed keys using a user-assigned identity.
- facilitates vnet integration through subnet delegation and private DNS zones.
- offers maintenance, high availability, options for robust management.
- allows creation of empty databases.
- utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.13)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [azurerm_postgresql_flexible_server.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) (resource)
- [azurerm_postgresql_flexible_server_active_directory_administrator.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) (resource)
- [azurerm_postgresql_flexible_server_configuration.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) (resource)
- [azurerm_postgresql_flexible_server_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) (resource)
- [azurerm_postgresql_flexible_server_firewall_rule.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) (resource)
- [azurerm_role_assignment.identity_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_password.psql_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [azuread_service_principal.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_user.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_instance"></a> [instance](#input\_instance)

Description: describes psql server related configuration

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region and can be used if location is not specified inside the object.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: default resource group and can be used if resourcegroup is not specified inside the object.

Type: `string`

Default: `null`

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

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-psql/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-psql" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/postgresql/)
