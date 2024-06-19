# route rbac policy config schema Schema

```txt
route_rbac_policy.json#/properties/policies/items
```

titanSideCars.ingress.route.rbac.policy or titanSideCars.egress.route.rbac.policy

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                          |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [route\_rbac.json\*](../out/route_rbac.json "open original schema") |

## items Type

`object` ([route rbac policy config schema](route_rbac-properties-list-of-rbac-policy-route-rbac-policy-config-schema.md))

# items Properties

| Property            | Type     | Required | Nullable       | Defined by                                                                                                                             |
| :------------------ | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)       | `string` | Required | cannot be null | [route rbac policy config schema](route_rbac_policy-properties-name.md "route_rbac_policy.json#/properties/name")                      |
| [message](#message) | `string` | Optional | cannot be null | [route rbac policy config schema](route_rbac_policy-properties-message.md "route_rbac_policy.json#/properties/message")                |
| [rules](#rules)     | `array`  | Required | cannot be null | [route rbac policy config schema](route_rbac_policy-properties-list-of-rbac-policy-rule.md "route_rbac_policy.json#/properties/rules") |

## name



`name`

* is required

* Type: `string`

* cannot be null

* defined in: [route rbac policy config schema](route_rbac_policy-properties-name.md "route_rbac_policy.json#/properties/name")

### name Type

`string`

## message



`message`

* is optional

* Type: `string`

* cannot be null

* defined in: [route rbac policy config schema](route_rbac_policy-properties-message.md "route_rbac_policy.json#/properties/message")

### message Type

`string`

## rules



`rules`

* is required

* Type: `object[]` ([route rbac police rule config schema](route_rbac_policy-properties-list-of-rbac-policy-rule-route-rbac-police-rule-config-schema.md))

* cannot be null

* defined in: [route rbac policy config schema](route_rbac_policy-properties-list-of-rbac-policy-rule.md "route_rbac_policy.json#/properties/rules")

### rules Type

`object[]` ([route rbac police rule config schema](route_rbac_policy-properties-list-of-rbac-policy-rule-route-rbac-police-rule-config-schema.md))
