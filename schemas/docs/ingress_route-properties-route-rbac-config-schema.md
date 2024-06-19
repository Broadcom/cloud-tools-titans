# route rbac config schema Schema

```txt
route_rbac.json#/properties/rbac
```

titanSideCars.ingress.route.rbac or titanSideCars.egress.route.rbac

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [ingress\_route.json\*](../out/ingress_route.json "open original schema") |

## rbac Type

`object` ([route rbac config schema](ingress_route-properties-route-rbac-config-schema.md))

# rbac Properties

| Property              | Type      | Required | Nullable       | Defined by                                                                                                      |
| :-------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)   | `boolean` | Optional | cannot be null | [route rbac config schema](route_rbac-properties-enabled.md "route_rbac.json#/properties/enabled")              |
| [policies](#policies) | `array`   | Optional | cannot be null | [route rbac config schema](route_rbac-properties-list-of-rbac-policy.md "route_rbac.json#/properties/policies") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route rbac config schema](route_rbac-properties-enabled.md "route_rbac.json#/properties/enabled")

### enabled Type

`boolean`

## policies



`policies`

* is optional

* Type: `object[]` ([route rbac policy config schema](route_rbac-properties-list-of-rbac-policy-route-rbac-policy-config-schema.md))

* cannot be null

* defined in: [route rbac config schema](route_rbac-properties-list-of-rbac-policy.md "route_rbac.json#/properties/policies")

### policies Type

`object[]` ([route rbac policy config schema](route_rbac-properties-list-of-rbac-policy-route-rbac-policy-config-schema.md))
