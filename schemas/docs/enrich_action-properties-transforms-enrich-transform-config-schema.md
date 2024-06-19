# enrich transform config schema Schema

```txt
enrich_transform.json#/properties/transforms/items
```

\[ingress|egress].enrichment.actions.action.transforms or \[ingress|egress].routes.enrich.actions.action.transforms

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [enrich\_action.json\*](../out/enrich_action.json "open original schema") |

## items Type

`object` ([enrich transform config schema](enrich_action-properties-transforms-enrich-transform-config-schema.md))

# items Properties

| Property                  | Type     | Required | Nullable       | Defined by                                                                                                                               |
| :------------------------ | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| [func](#func)             | `string` | Required | cannot be null | [enrich transform config schema](enrich_transform-properties-func.md "enrich_transform.json#/properties/func")                           |
| [parameters](#parameters) | `array`  | Optional | cannot be null | [enrich transform config schema](enrich_transform-properties-list-of-enrich-parameter.md "enrich_transform.json#/properties/parameters") |

## func



`func`

* is required

* Type: `string`

* cannot be null

* defined in: [enrich transform config schema](enrich_transform-properties-func.md "enrich_transform.json#/properties/func")

### func Type

`string`

### func Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value             | Explanation |
| :---------------- | :---------- |
| `"trim_prefix"`   |             |
| `"base64_decode"` |             |
| `"split"`         |             |
| `"scanf"`         |             |

## parameters



`parameters`

* is optional

* Type: `string[]`

* cannot be null

* defined in: [enrich transform config schema](enrich_transform-properties-list-of-enrich-parameter.md "enrich_transform.json#/properties/parameters")

### parameters Type

`string[]`
