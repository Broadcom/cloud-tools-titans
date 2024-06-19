# enrich header match config schema Schema

```txt
enrich_action_match_header.json#/properties/match_headers/items
```

\[ingress|egress].enrichment.actions.action.match\_header or \[ingress|egress].routes.enrich.actions.action.match\_header

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [enrich\_action.json\*](../out/enrich_action.json "open original schema") |

## items Type

`object` ([enrich header match config schema](enrich_action-properties-list-of-enrich-action-match-header-enrich-header-match-config-schema.md))

all of

* one (and only one) of

  * not

    * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-0-oneof-0-not.md "check type definition")

  * not

    * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-0-oneof-1-not.md "check type definition")

  * not

    * any of

      * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-0-oneof-2-not-anyof-0.md "check type definition")

      * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-0-oneof-2-not-anyof-1.md "check type definition")

* one (and only one) of

  * not

    * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-1-oneof-0-not.md "check type definition")

  * not

    * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-1-oneof-1-not.md "check type definition")

  * not

    * any of

      * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-1-oneof-2-not-anyof-0.md "check type definition")

      * [Untitled undefined type in enrich header match config schema](enrich_action_match_header-allof-1-oneof-2-not-anyof-1.md "check type definition")

# items Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                  |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| [inv](#inv)         | `boolean` | Optional | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-inv.md "enrich_action_match_header.json#/properties/inv")         |
| [invert](#invert)   | `boolean` | Optional | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-invert.md "enrich_action_match_header.json#/properties/invert")   |
| [name](#name)       | `string`  | Optional | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-name.md "enrich_action_match_header.json#/properties/name")       |
| [pattern](#pattern) | `string`  | Required | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-pattern.md "enrich_action_match_header.json#/properties/pattern") |
| [val](#val)         | `string`  | Optional | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-val.md "enrich_action_match_header.json#/properties/val")         |
| [value](#value)     | `string`  | Optional | cannot be null | [enrich header match config schema](enrich_action_match_header-properties-value.md "enrich_action_match_header.json#/properties/value")     |

## inv



`inv`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-inv.md "enrich_action_match_header.json#/properties/inv")

### inv Type

`boolean`

## invert



`invert`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-invert.md "enrich_action_match_header.json#/properties/invert")

### invert Type

`boolean`

## name



`name`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-name.md "enrich_action_match_header.json#/properties/name")

### name Type

`string`

## pattern



`pattern`

* is required

* Type: `string`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-pattern.md "enrich_action_match_header.json#/properties/pattern")

### pattern Type

`string`

### pattern Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"prefix"`  |             |
| `"sw"`      |             |
| `"exact"`   |             |
| `"eq"`      |             |
| `"contain"` |             |
| `"co"`      |             |
| `"exist"`   |             |
| `"ex"`      |             |
| `"suffix"`  |             |
| `"ew"`      |             |
| `"regex"`   |             |

## val

This should not be specified if pattern is 'ex' or 'exist'

`val`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-val.md "enrich_action_match_header.json#/properties/val")

### val Type

`string`

## value

This should not be specified if pattern is 'ex' or 'exist'

`value`

* is optional

* Type: `string`

* cannot be null

* defined in: [enrich header match config schema](enrich_action_match_header-properties-value.md "enrich_action_match_header.json#/properties/value")

### value Type

`string`
