# route rbac police rule config schema Schema

```txt
route_rbac_policy_rule.json
```

titanSideCars.ingress.route.rbac.policy.rule or titanSideCars.egress.route.rbac.policy.rule

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                  |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [route\_rbac\_policy\_rule.json](../out/route_rbac_policy_rule.json "open original schema") |

## route rbac police rule config schema Type

`object` ([route rbac police rule config schema](route_rbac_policy_rule.md))

one (and only one) of

* [Untitled undefined type in route rbac police rule config schema](route_rbac_policy_rule-oneof-0.md "check type definition")

# route rbac police rule config schema Properties

| Property    | Type      | Required | Nullable       | Defined by                                                                                                                     |
| :---------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| [inv](#inv) | `boolean` | Optional | cannot be null | [route rbac police rule config schema](route_rbac_policy_rule-properties-inv.md "route_rbac_policy_rule.json#/properties/inv") |
| [lop](#lop) | `string`  | Required | cannot be null | [route rbac police rule config schema](route_rbac_policy_rule-properties-lop.md "route_rbac_policy_rule.json#/properties/lop") |
| [op](#op)   | `string`  | Required | cannot be null | [route rbac police rule config schema](route_rbac_policy_rule-properties-op.md "route_rbac_policy_rule.json#/properties/op")   |
| [rop](#rop) | `string`  | Optional | cannot be null | [route rbac police rule config schema](route_rbac_policy_rule-properties-rop.md "route_rbac_policy_rule.json#/properties/rop") |
| [val](#val) | `string`  | Optional | cannot be null | [route rbac police rule config schema](route_rbac_policy_rule-properties-val.md "route_rbac_policy_rule.json#/properties/val") |

## inv



`inv`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route rbac police rule config schema](route_rbac_policy_rule-properties-inv.md "route_rbac_policy_rule.json#/properties/inv")

### inv Type

`boolean`

## lop



`lop`

* is required

* Type: `string`

* cannot be null

* defined in: [route rbac police rule config schema](route_rbac_policy_rule-properties-lop.md "route_rbac_policy_rule.json#/properties/lop")

### lop Type

`string`

### lop Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^request[.](body|headers|query|token)\[[a-zA-Z-_]+\]$
```

[try pattern](https://regexr.com/?expression=%5Erequest%5B.%5D\(body%7Cheaders%7Cquery%7Ctoken\)%5C%5B%5Ba-zA-Z-_%5D%2B%5C%5D%24 "try regular expression with regexr.com")

## op



`op`

* is required

* Type: `string`

* cannot be null

* defined in: [route rbac police rule config schema](route_rbac_policy_rule-properties-op.md "route_rbac_policy_rule.json#/properties/op")

### op Type

`string`

### op Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value   | Explanation |
| :------ | :---------- |
| `"ex"`  |             |
| `"eq"`  |             |
| `"ne"`  |             |
| `"sw"`  |             |
| `"nsw"` |             |
| `"ew"`  |             |
| `"new"` |             |
| `"co"`  |             |
| `"nco"` |             |
| `"has"` |             |

## rop



`rop`

* is optional

* Type: `string`

* cannot be null

* defined in: [route rbac police rule config schema](route_rbac_policy_rule-properties-rop.md "route_rbac_policy_rule.json#/properties/rop")

### rop Type

`string`

### rop Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^request[.](body|headers|query|token)\[[a-zA-Z-_]+\]$
```

[try pattern](https://regexr.com/?expression=%5Erequest%5B.%5D\(body%7Cheaders%7Cquery%7Ctoken\)%5C%5B%5Ba-zA-Z-_%5D%2B%5C%5D%24 "try regular expression with regexr.com")

## val



`val`

* is optional

* Type: `string`

* cannot be null

* defined in: [route rbac police rule config schema](route_rbac_policy_rule-properties-val.md "route_rbac_policy_rule.json#/properties/val")

### val Type

`string`
