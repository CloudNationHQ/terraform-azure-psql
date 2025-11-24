# Changelog

## [4.1.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v4.0.2...v4.1.0) (2025-11-24)


### Features

* added missing properties, updated example ([#68](https://github.com/CloudNationHQ/terraform-azure-psql/issues/68)) ([29595b3](https://github.com/CloudNationHQ/terraform-azure-psql/commit/29595b3783d30db457dc3880c9f2a5c432372d9c))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#51](https://github.com/CloudNationHQ/terraform-azure-psql/issues/51)) ([4b205a6](https://github.com/CloudNationHQ/terraform-azure-psql/commit/4b205a65a12b2b0baceae346508570b2139c461c))
* **deps:** bump golang.org/x/crypto from 0.31.0 to 0.35.0 in /tests ([#53](https://github.com/CloudNationHQ/terraform-azure-psql/issues/53)) ([5a8f5fd](https://github.com/CloudNationHQ/terraform-azure-psql/commit/5a8f5fd206e26be58dfa4769017d338e41e532b6))

## [4.0.2](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v4.0.1...v4.0.2) (2025-10-02)


### Bug Fixes

* prevent data source lookup when object_id is provided ([#66](https://github.com/CloudNationHQ/terraform-azure-psql/issues/66)) ([d84b8d2](https://github.com/CloudNationHQ/terraform-azure-psql/commit/d84b8d274bb7eff1d59c2b78ae5a263c0ab50e82))

## [4.0.1](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v4.0.0...v4.0.1) (2025-07-25)


### Bug Fixes

* made key 'backup' optional under 'customer_managed_key' object ([#61](https://github.com/CloudNationHQ/terraform-azure-psql/issues/61)) ([a85cf61](https://github.com/CloudNationHQ/terraform-azure-psql/commit/a85cf61741a211b20710d20a7bed05311865fc52))

## [4.0.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v3.2.0...v4.0.0) (2025-06-30)


### ⚠ BREAKING CHANGES

* rename resource_group to resource_group_name ([#59](https://github.com/CloudNationHQ/terraform-azure-psql/issues/59))
* enhance AD admin configuration, allow multiple admins ([#57](https://github.com/CloudNationHQ/terraform-azure-psql/issues/57))

### Features

* enhance AD admin configuration, allow multiple admins ([#57](https://github.com/CloudNationHQ/terraform-azure-psql/issues/57)) ([0f68555](https://github.com/CloudNationHQ/terraform-azure-psql/commit/0f68555c25029c343a7653a1287bcd25957b1ea2))
* rename resource_group to resource_group_name ([#59](https://github.com/CloudNationHQ/terraform-azure-psql/issues/59)) ([e0cd401](https://github.com/CloudNationHQ/terraform-azure-psql/commit/e0cd4018b747ea800d73919c65e1212983c65f2f))

## [3.2.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v3.1.0...v3.2.0) (2025-01-20)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#45](https://github.com/CloudNationHQ/terraform-azure-psql/issues/45)) ([38e49cb](https://github.com/CloudNationHQ/terraform-azure-psql/commit/38e49cbdd14570042f96f95a8dccc0917d38c500))
* **deps:** bump golang.org/x/net from 0.31.0 to 0.33.0 in /tests ([#48](https://github.com/CloudNationHQ/terraform-azure-psql/issues/48)) ([de1a118](https://github.com/CloudNationHQ/terraform-azure-psql/commit/de1a1188f9e85d09d93caf54bea8acf28f169188))
* remove temporary files when deployment tests fails ([#46](https://github.com/CloudNationHQ/terraform-azure-psql/issues/46)) ([25751c9](https://github.com/CloudNationHQ/terraform-azure-psql/commit/25751c977a1ce65d674420c0884cdd63aa658001))

## [3.1.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v3.0.0...v3.1.0) (2024-11-11)


### Features

* enhance testing with sequential, parallel modes and flags for exceptions and skip-destroy ([#42](https://github.com/CloudNationHQ/terraform-azure-psql/issues/42)) ([305c68c](https://github.com/CloudNationHQ/terraform-azure-psql/commit/305c68c08bae6d468cb05399b1b551c39f5e0c63))

## [3.0.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v2.1.0...v3.0.0) (2024-10-30)


### ⚠ BREAKING CHANGES

* update provider azuread to new major version, renamed properties.  ([#40](https://github.com/CloudNationHQ/terraform-azure-psql/issues/40))

### Features

* update provider azuread to new major version, renamed properties.  ([#40](https://github.com/CloudNationHQ/terraform-azure-psql/issues/40)) ([506a9c8](https://github.com/CloudNationHQ/terraform-azure-psql/commit/506a9c83cc0b20c8548b0266fa062de8ffa2edc1))

## [2.1.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v2.0.0...v2.1.0) (2024-10-11)


### Features

* auto generated docs and refine makefile ([#37](https://github.com/CloudNationHQ/terraform-azure-psql/issues/37)) ([93a97af](https://github.com/CloudNationHQ/terraform-azure-psql/commit/93a97af7157e8ccfb27b0f58fe0df5f8f46190ac))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#36](https://github.com/CloudNationHQ/terraform-azure-psql/issues/36)) ([f93b84d](https://github.com/CloudNationHQ/terraform-azure-psql/commit/f93b84d23484ca087a6bcdc67925fe7c9b7cbbeb))

## [2.0.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v1.1.0...v2.0.0) (2024-09-24)


### ⚠ BREAKING CHANGES

* Version 4 of the azurerm provider includes breaking changes.

### Features

* upgrade azurerm provider to v4 ([#34](https://github.com/CloudNationHQ/terraform-azure-psql/issues/34)) ([ba41165](https://github.com/CloudNationHQ/terraform-azure-psql/commit/ba41165f1c7b2a3b17882a00b2f3d5f02586cd59))

### Upgrade from v1.1.0 to v2.0.0:

- Update module reference to: `version = "~> 2.0"`

## [1.1.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v1.0.0...v1.1.0) (2024-08-29)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#27](https://github.com/CloudNationHQ/terraform-azure-psql/issues/27)) ([247417a](https://github.com/CloudNationHQ/terraform-azure-psql/commit/247417a24dfdf40002774f440d6373073ec98cc6))
* update documentation ([#31](https://github.com/CloudNationHQ/terraform-azure-psql/issues/31)) ([d4de9e7](https://github.com/CloudNationHQ/terraform-azure-psql/commit/d4de9e78a4b8d5b3a70c62c521ee8e63e81bbef8))

## [1.0.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.7.0...v1.0.0) (2024-08-07)


### ⚠ BREAKING CHANGES

* update of data structure as variable got renamed
    * feat: add psql flexible server configurations, including example and updated docs
    * feat: update module versions to 1.0

### Upgrade from v0.7.0 to v1.0.0

- Update **module reference** to: `version = "~> 1.0"`
- Rename **variable** (optional):
   * resourcegroup -> resource_group

### Features

* add psql flexible server configurations ([#29](https://github.com/CloudNationHQ/terraform-azure-psql/issues/29)) ([912abc0](https://github.com/CloudNationHQ/terraform-azure-psql/commit/912abc0df8a4e095ba8d83d876ee94b559b05b8d))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.6.0...v0.7.0) (2024-07-04)


### Features

* update contribution docs ([#25](https://github.com/CloudNationHQ/terraform-azure-psql/issues/25)) ([3353451](https://github.com/CloudNationHQ/terraform-azure-psql/commit/3353451751741f2cda17ca106114c6ce69723c75))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.5.0...v0.6.0) (2024-07-03)


### Features

* add public_network_access_enabled property to enhance network configuration ([#23](https://github.com/CloudNationHQ/terraform-azure-psql/issues/23)) ([77bbad3](https://github.com/CloudNationHQ/terraform-azure-psql/commit/77bbad33a7555c72193de245d79821e07435eda4))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.4.0...v0.5.0) (2024-07-02)


### Features

* add issue template ([#20](https://github.com/CloudNationHQ/terraform-azure-psql/issues/20)) ([7b6b1bb](https://github.com/CloudNationHQ/terraform-azure-psql/commit/7b6b1bbc50296add8e29624772d20f18f4d42623))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#19](https://github.com/CloudNationHQ/terraform-azure-psql/issues/19)) ([c4cbba4](https://github.com/CloudNationHQ/terraform-azure-psql/commit/c4cbba4cccabb2ae031f5f63be1629a7ac70b06c))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#18](https://github.com/CloudNationHQ/terraform-azure-psql/issues/18)) ([6f6357d](https://github.com/CloudNationHQ/terraform-azure-psql/commit/6f6357df78c38c4a332785e3ec12fb409378ceca))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.3.0...v0.4.0) (2024-06-08)


### Features

* create pull request template ([#16](https://github.com/CloudNationHQ/terraform-azure-psql/issues/16)) ([6d0de8b](https://github.com/CloudNationHQ/terraform-azure-psql/commit/6d0de8b9c2d46bc3d172f43c14ccf97d2b45126d))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#15](https://github.com/CloudNationHQ/terraform-azure-psql/issues/15)) ([8c8ef06](https://github.com/CloudNationHQ/terraform-azure-psql/commit/8c8ef06706e8df4dc3a7fafb1f3f12398ef32434))
* **deps:** bump github.com/hashicorp/go-getter in /tests ([#13](https://github.com/CloudNationHQ/terraform-azure-psql/issues/13)) ([ac146ac](https://github.com/CloudNationHQ/terraform-azure-psql/commit/ac146ac9a21e596ce5bd08c52b98a86de5004fdc))
* **deps:** bump golang.org/x/net from 0.17.0 to 0.23.0 in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-psql/issues/12)) ([c74d3cb](https://github.com/CloudNationHQ/terraform-azure-psql/commit/c74d3cbdc00b5e9815637d3d9e25d095955bba1b))
* **deps:** bump google.golang.org/protobuf in /tests ([#10](https://github.com/CloudNationHQ/terraform-azure-psql/issues/10)) ([713359b](https://github.com/CloudNationHQ/terraform-azure-psql/commit/713359b8bc0e9997322ab5af5754417885ec9023))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.2.1...v0.3.0) (2024-03-12)


### Features

* add override name for administrator login ([#8](https://github.com/CloudNationHQ/terraform-azure-psql/issues/8)) ([f91f744](https://github.com/CloudNationHQ/terraform-azure-psql/commit/f91f7442c9fee531cef46fbd3871a04a1481db0a))

## [0.2.1](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.2.0...v0.2.1) (2024-03-11)


### Bug Fixes

* cmk backup key is optional now ([#6](https://github.com/CloudNationHQ/terraform-azure-psql/issues/6)) ([18854d2](https://github.com/CloudNationHQ/terraform-azure-psql/commit/18854d23a8946361f9a8ade3451e9ea18e6c6561))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-psql/compare/v0.1.0...v0.2.0) (2024-02-19)


### Features

* **deps:** Bump github.com/gruntwork-io/terratest from 0.46.8 to 0.46.11 in /tests ([#4](https://github.com/CloudNationHQ/terraform-azure-psql/issues/4)) ([3abd1ce](https://github.com/CloudNationHQ/terraform-azure-psql/commit/3abd1ce580af7fca953fea347761c39edfc56192))
* **deps:** Bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#3](https://github.com/CloudNationHQ/terraform-azure-psql/issues/3)) ([fcde932](https://github.com/CloudNationHQ/terraform-azure-psql/commit/fcde93276682ad37786ce484be8bc46c832ce116))

## 0.1.0 (2024-02-19)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-psql/issues/1)) ([05d036b](https://github.com/CloudNationHQ/terraform-azure-psql/commit/05d036b765f6779f419251d9b8dd37b5f5bad847))
