# route ratelimit config schema Schema

```txt
route_ratelimit.json
```

route.ratelimit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                  |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [route\_ratelimit.json](../out/route_ratelimit.json "open original schema") |

## route ratelimit config schema Type

`object` ([route ratelimit config schema](route_ratelimit.md))

# route ratelimit config schema Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                               |
| :------------------ | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [route ratelimit config schema](route_ratelimit-properties-enabled.md "route_ratelimit.json#/properties/enabled")                        |
| [name](#name)       | `string`  | Optional | cannot be null | [route ratelimit config schema](route_ratelimit-properties-name.md "route_ratelimit.json#/properties/name")                              |
| [actions](#actions) | `array`   | Optional | cannot be null | [route ratelimit config schema](route_ratelimit-properties-list-of-ratelimit-action-match.md "route_ratelimit.json#/properties/actions") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route ratelimit config schema](route_ratelimit-properties-enabled.md "route_ratelimit.json#/properties/enabled")

### enabled Type

`boolean`

## name



`name`

* is optional

* Type: `string`

* cannot be null

* defined in: [route ratelimit config schema](route_ratelimit-properties-name.md "route_ratelimit.json#/properties/name")

### name Type

`string`

## actions



`actions`

* is optional

* Type: `object[]` ([ratelimit action match config schema](route_ratelimit-properties-list-of-ratelimit-action-match-ratelimit-action-match-config-schema.md))

* cannot be null

* defined in: [route ratelimit config schema](route_ratelimit-properties-list-of-ratelimit-action-match.md "route_ratelimit.json#/properties/actions")

### actions Type

`object[]` ([ratelimit action match config schema](route_ratelimit-properties-list-of-ratelimit-action-match-ratelimit-action-match-config-schema.md))
