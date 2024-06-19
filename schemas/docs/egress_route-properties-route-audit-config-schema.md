# route audit config schema Schema

```txt
route_audit.json#/properties/audit
```

titanSideCars.ingress.route.audit or titanSideCars.egress.route.audit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [egress\_route.json\*](../out/egress_route.json "open original schema") |

## audit Type

`object` ([route audit config schema](egress_route-properties-route-audit-config-schema.md))

# audit Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                            |
| :------------------ | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [route audit config schema](route_audit-properties-enabled.md "route_audit.json#/properties/enabled") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route audit config schema](route_audit-properties-enabled.md "route_audit.json#/properties/enabled")

### enabled Type

`boolean`
