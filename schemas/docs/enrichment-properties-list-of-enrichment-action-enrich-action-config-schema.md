# enrich action config schema Schema

```txt
enrich_action.json#/properties/actions/items
```

\[ingress|egress].enrichment.actions.action or \[ingress|egress].routes.enrich.actions.action

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [enrichment.json\*](../out/enrichment.json "open original schema") |

## items Type

`object` ([enrich action config schema](enrichment-properties-list-of-enrichment-action-enrich-action-config-schema.md))

# items Properties

| Property                          | Type          | Required | Nullable       | Defined by                                                                                                                                   |
| :-------------------------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------- |
| [action](#action)                 | `string`      | Required | cannot be null | [enrich action config schema](enrich_action-properties-action.md "enrich_action.json#/properties/action")                                    |
| [from](#from)                     | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-from.md "enrich_action.json#/properties/from")                                        |
| [if\_contain](#if_contain)        | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-if_contain.md "enrich_action.json#/properties/if_contain")                            |
| [if\_eq](#if_eq)                  | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-if_eq.md "enrich_action.json#/properties/if_eq")                                      |
| [if\_start\_with](#if_start_with) | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-if_start_with.md "enrich_action.json#/properties/if_start_with")                      |
| [match\_headers](#match_headers)  | `array`       | Optional | cannot be null | [enrich action config schema](enrich_action-properties-list-of-enrich-action-match-header.md "enrich_action.json#/properties/match_headers") |
| [path\_prefix](#path_prefix)      | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-path_prefix.md "enrich_action.json#/properties/path_prefix")                          |
| [to](#to)                         | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-to.md "enrich_action.json#/properties/to")                                            |
| [transforms](#transforms)         | Not specified | Optional | cannot be null | [enrich action config schema](enrich_action-properties-transforms.md "enrich_action.json#/properties/transforms")                            |
| [with](#with)                     | `string`      | Optional | cannot be null | [enrich action config schema](enrich_action-properties-with.md "enrich_action.json#/properties/with")                                        |

## action



`action`

* is required

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-action.md "enrich_action.json#/properties/action")

### action Type

`string`

### action Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"extract"` |             |
| `"decode"`  |             |

## from



`from`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-from.md "enrich_action.json#/properties/from")

### from Type

`string`

### from Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(token|header|query)\..+$
```

[try pattern](https://regexr.com/?expression=%5E\(token%7Cheader%7Cquery\)%5C..%2B%24 "try regular expression with regexr.com")

## if\_contain



`if_contain`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-if_contain.md "enrich_action.json#/properties/if_contain")

### if\_contain Type

`string`

## if\_eq



`if_eq`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-if_eq.md "enrich_action.json#/properties/if_eq")

### if\_eq Type

`string`

## if\_start\_with



`if_start_with`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-if_start_with.md "enrich_action.json#/properties/if_start_with")

### if\_start\_with Type

`string`

## match\_headers



`match_headers`

* is optional

* Type: `object[]` ([enrich header match config schema](enrich_action-properties-list-of-enrich-action-match-header-enrich-header-match-config-schema.md))

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-list-of-enrich-action-match-header.md "enrich_action.json#/properties/match_headers")

### match\_headers Type

`object[]` ([enrich header match config schema](enrich_action-properties-list-of-enrich-action-match-header-enrich-header-match-config-schema.md))

## path\_prefix



`path_prefix`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-path_prefix.md "enrich_action.json#/properties/path_prefix")

### path\_prefix Type

`string`

## to



`to`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-to.md "enrich_action.json#/properties/to")

### to Type

`string`

## transforms



`transforms`

* is optional

* Type: unknown

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-transforms.md "enrich_action.json#/properties/transforms")

### transforms Type

unknown

## with



`with`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich action config schema](enrich_action-properties-with.md "enrich_action.json#/properties/with")

### with Type

`string`
