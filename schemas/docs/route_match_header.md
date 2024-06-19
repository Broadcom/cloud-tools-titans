# route match header config schema Schema

```txt
route_match_header.json
```

titanSideCars.\[ingress|egress].route.match.headers

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                         |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [route\_match\_header.json](../out/route_match_header.json "open original schema") |

## route match header config schema Type

`object` ([route match header config schema](route_match_header.md))

one (and only one) of

* [Untitled undefined type in route match header config schema](route_match_header-oneof-0.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-1.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-2.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-3.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-4.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-5.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-6.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-7.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-8.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-9.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-10.md "check type definition")

* [Untitled undefined type in route match header config schema](route_match_header-oneof-11.md "check type definition")

# route match header config schema Properties

| Property          | Type      | Required | Nullable       | Defined by                                                                                                               |
| :---------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------- |
| [key](#key)       | `string`  | Required | cannot be null | [route match header config schema](route_match_header-properties-key.md "route_match_header.json#/properties/key")       |
| [source](#source) | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-source.md "route_match_header.json#/properties/source") |
| [eq](#eq)         | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-eq.md "route_match_header.json#/properties/eq")         |
| [neq](#neq)       | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-neq.md "route_match_header.json#/properties/neq")       |
| [sw](#sw)         | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-sw.md "route_match_header.json#/properties/sw")         |
| [nsw](#nsw)       | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-nsw.md "route_match_header.json#/properties/nsw")       |
| [ew](#ew)         | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-ew.md "route_match_header.json#/properties/ew")         |
| [new](#new)       | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-new.md "route_match_header.json#/properties/new")       |
| [co](#co)         | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-co.md "route_match_header.json#/properties/co")         |
| [nco](#nco)       | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-nco.md "route_match_header.json#/properties/nco")       |
| [lk](#lk)         | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-lk.md "route_match_header.json#/properties/lk")         |
| [nlk](#nlk)       | `string`  | Optional | cannot be null | [route match header config schema](route_match_header-properties-nlk.md "route_match_header.json#/properties/nlk")       |
| [pr](#pr)         | `boolean` | Optional | cannot be null | [route match header config schema](route_match_header-properties-pr.md "route_match_header.json#/properties/pr")         |
| [npr](#npr)       | `boolean` | Optional | cannot be null | [route match header config schema](route_match_header-properties-npr.md "route_match_header.json#/properties/npr")       |

## key



`key`

* is required

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-key.md "route_match_header.json#/properties/key")

### key Type

`string`

### key Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(:method|:path|:authority|:scheme|:status|(?!:).+)$
```

[try pattern](https://regexr.com/?expression=%5E\(%3Amethod%7C%3Apath%7C%3Aauthority%7C%3Ascheme%7C%3Astatus%7C\(%3F!%3A\).%2B\)%24 "try regular expression with regexr.com")

## source



`source`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-source.md "route_match_header.json#/properties/source")

### source Type

`string`

### source Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value        | Explanation |
| :----------- | :---------- |
| `"request"`  |             |
| `"response"` |             |

## eq



`eq`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-eq.md "route_match_header.json#/properties/eq")

### eq Type

`string`

## neq



`neq`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-neq.md "route_match_header.json#/properties/neq")

### neq Type

`string`

## sw



`sw`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-sw.md "route_match_header.json#/properties/sw")

### sw Type

`string`

## nsw



`nsw`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-nsw.md "route_match_header.json#/properties/nsw")

### nsw Type

`string`

## ew



`ew`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-ew.md "route_match_header.json#/properties/ew")

### ew Type

`string`

## new



`new`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-new.md "route_match_header.json#/properties/new")

### new Type

`string`

## co



`co`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-co.md "route_match_header.json#/properties/co")

### co Type

`string`

## nco



`nco`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-nco.md "route_match_header.json#/properties/nco")

### nco Type

`string`

## lk



`lk`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-lk.md "route_match_header.json#/properties/lk")

### lk Type

`string`

## nlk



`nlk`

* is optional

* Type: `string`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-nlk.md "route_match_header.json#/properties/nlk")

### nlk Type

`string`

## pr



`pr`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-pr.md "route_match_header.json#/properties/pr")

### pr Type

`boolean`

## npr



`npr`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route match header config schema](route_match_header-properties-npr.md "route_match_header.json#/properties/npr")

### npr Type

`boolean`
