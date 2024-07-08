# route metrics config schema Schema

```txt
route_metrics.json#/properties/metrics
```

titanSideCars.ingress.route.metrics or titanSideCars.egress.route.metrics

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [egress\_route.json\*](../out/egress_route.json "open original schema") |

## metrics Type

`object` ([route metrics config schema](egress_route-properties-route-metrics-config-schema.md))

# metrics Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                  |
| :------------------ | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [route metrics config schema](route_metrics-properties-enabled.md "route_metrics.json#/properties/enabled") |
| [name](#name)       | `string`  | Required | cannot be null | [route metrics config schema](route_metrics-properties-name.md "route_metrics.json#/properties/name")       |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [route metrics config schema](route_metrics-properties-enabled.md "route_metrics.json#/properties/enabled")

### enabled Type

`boolean`

## name



`name`

* is required

* Type: `string`

* cannot be null

* defined in: [route metrics config schema](route_metrics-properties-name.md "route_metrics.json#/properties/name")

### name Type

`string`
