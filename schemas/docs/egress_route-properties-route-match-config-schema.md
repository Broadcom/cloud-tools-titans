# route match config schema Schema

```txt
route_match.json#/properties/match
```

titanSideCars.\[ingress|egress|envoy.cluster].route.match

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [egress\_route.json\*](../out/egress_route.json "open original schema") |

## match Type

`object` ([route match config schema](egress_route-properties-route-match-config-schema.md))

one (and only one) of

* [Untitled undefined type in route match config schema](route_match-oneof-0.md "check type definition")

* [Untitled undefined type in route match config schema](route_match-oneof-1.md "check type definition")

* [Untitled undefined type in route match config schema](route_match-oneof-2.md "check type definition")

* not

  * any of

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-0.md "check type definition")

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-1.md "check type definition")

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-2.md "check type definition")

# match Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                               |
| :------------------ | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------- |
| [method](#method)   | `string` | Optional | cannot be null | [route match config schema](route_match-properties-method.md "route_match.json#/properties/method")                      |
| [path](#path)       | `string` | Optional | cannot be null | [route match config schema](route_match-properties-path.md "route_match.json#/properties/path")                          |
| [prefix](#prefix)   | `string` | Optional | cannot be null | [route match config schema](route_match-properties-prefix.md "route_match.json#/properties/prefix")                      |
| [regex](#regex)     | `string` | Optional | cannot be null | [route match config schema](route_match-properties-regex.md "route_match.json#/properties/regex")                        |
| [headers](#headers) | `array`  | Optional | cannot be null | [route match config schema](route_match-properties-list-of-route-match-header.md "route_match.json#/properties/headers") |

## method



`method`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match config schema](route_match-properties-method.md "route_match.json#/properties/method")

### method Type

`string`

## path



`path`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match config schema](route_match-properties-path.md "route_match.json#/properties/path")

### path Type

`string`

## prefix



`prefix`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match config schema](route_match-properties-prefix.md "route_match.json#/properties/prefix")

### prefix Type

`string`

### prefix Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^/([a-zA-Z0-9_\-.]+/?)*$
```

[try pattern](https://regexr.com/?expression=%5E%2F\(%5Ba-zA-Z0-9_%5C-.%5D%2B%2F%3F\)*%24 "try regular expression with regexr.com")

## regex



`regex`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match config schema](route_match-properties-regex.md "route_match.json#/properties/regex")

### regex Type

`string`

## headers



`headers`

* is optional

* Type: `object[]` ([route match header config schema](route_match-properties-list-of-route-match-header-route-match-header-config-schema.md))

* cannot be null

* defined in: [route match config schema](route_match-properties-list-of-route-match-header.md "route_match.json#/properties/headers")

### headers Type

`object[]` ([route match header config schema](route_match-properties-list-of-route-match-header-route-match-header-config-schema.md))
