# Changelog

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
