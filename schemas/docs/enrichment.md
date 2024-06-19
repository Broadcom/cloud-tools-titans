# enrichment config schema Schema

```txt
enrichment.json
```

titanSideCars.ingress.enrichment

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                       |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [enrichment.json](../out/enrichment.json "open original schema") |

## enrichment config schema Type

`object` ([enrichment config schema](enrichment.md))

# enrichment config schema Properties

| Property                                     | Type      | Required | Nullable       | Defined by                                                                                                                 |
| :------------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------- |
| [actions](#actions)                          | `array`   | Optional | cannot be null | [enrichment config schema](enrichment-properties-list-of-enrichment-action.md "enrichment.json#/properties/actions")       |
| [auth\_address](#auth_address)               | `string`  | Optional | cannot be null | [enrichment config schema](enrichment-properties-auth_address.md "enrichment.json#/properties/auth_address")               |
| [auth\_host](#auth_host)                     | `string`  | Optional | cannot be null | [enrichment config schema](enrichment-properties-auth_host.md "enrichment.json#/properties/auth_host")                     |
| [authentication\_path](#authentication_path) | `string`  | Optional | cannot be null | [enrichment config schema](enrichment-properties-authentication_path.md "enrichment.json#/properties/authentication_path") |
| [identity\_host](#identity_host)             | `string`  | Optional | cannot be null | [enrichment config schema](enrichment-properties-identity_host.md "enrichment.json#/properties/identity_host")             |
| [max\_page\_size](#max_page_size)            | `integer` | Optional | cannot be null | [enrichment config schema](enrichment-properties-max_page_size.md "enrichment.json#/properties/max_page_size")             |
| [privs\_path](#privs_path)                   | `string`  | Optional | cannot be null | [enrichment config schema](enrichment-properties-privs_path.md "enrichment.json#/properties/privs_path")                   |
| [tenancy\_check](#tenancy_check)             | `boolean` | Optional | cannot be null | [enrichment config schema](enrichment-properties-tenancy_check.md "enrichment.json#/properties/tenancy_check")             |

## actions



`actions`

* is optional

* Type: `object[]` ([enrich action config schema](enrichment-properties-list-of-enrichment-action-enrich-action-config-schema.md))

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-list-of-enrichment-action.md "enrichment.json#/properties/actions")

### actions Type

`object[]` ([enrich action config schema](enrichment-properties-list-of-enrichment-action-enrich-action-config-schema.md))

## auth\_address



`auth_address`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-auth_address.md "enrichment.json#/properties/auth_address")

### auth\_address Type

`string`

## auth\_host



`auth_host`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-auth_host.md "enrichment.json#/properties/auth_host")

### auth\_host Type

`string`

## authentication\_path



`authentication_path`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-authentication_path.md "enrichment.json#/properties/authentication_path")

### authentication\_path Type

`string`

## identity\_host



`identity_host`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-identity_host.md "enrichment.json#/properties/identity_host")

### identity\_host Type

`string`

## max\_page\_size



`max_page_size`

* is optional

* Type: `integer`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-max_page_size.md "enrichment.json#/properties/max_page_size")

### max\_page\_size Type

`integer`

## privs\_path



`privs_path`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-privs_path.md "enrichment.json#/properties/privs_path")

### privs\_path Type

`string`

## tenancy\_check



`tenancy_check`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [enrichment config schema](enrichment-properties-tenancy_check.md "enrichment.json#/properties/tenancy_check")

### tenancy\_check Type

`boolean`
