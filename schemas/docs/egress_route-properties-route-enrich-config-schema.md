# route enrich config schema Schema

```txt
route_enrich.json#/properties/enrich
```

titanSideCars.ingress.route.enrich or titanSideCars.egress.route.enrich

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [egress\_route.json\*](../out/egress_route.json "open original schema") |

## enrich Type

`object` ([route enrich config schema](egress_route-properties-route-enrich-config-schema.md))

any of

* [Untitled undefined type in route enrich config schema](route_enrich-anyof-0.md "check type definition")

* [Untitled undefined type in route enrich config schema](route_enrich-anyof-1.md "check type definition")

# enrich Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                             |
| :------------------ | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [route enrich config schema](route_enrich-properties-enabled.md "route_enrich.json#/properties/enabled")               |
| [actions](#actions) | `array`   | Optional | cannot be null | [route enrich config schema](route_enrich-properties-list-of-enrich-action.md "route_enrich.json#/properties/actions") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route enrich config schema](route_enrich-properties-enabled.md "route_enrich.json#/properties/enabled")

### enabled Type

`boolean`

## actions



`actions`

* is optional

* Type: `object[]` ([enrich action config schema](enrichment-properties-list-of-enrichment-action-enrich-action-config-schema.md))

* cannot be null

* defined in: [route enrich config schema](route_enrich-properties-list-of-enrich-action.md "route_enrich.json#/properties/actions")

### actions Type

`object[]` ([enrich action config schema](enrichment-properties-list-of-enrichment-action-enrich-action-config-schema.md))
