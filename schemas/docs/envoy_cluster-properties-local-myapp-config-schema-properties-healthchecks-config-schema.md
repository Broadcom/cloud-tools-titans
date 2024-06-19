# healthChecks config schema Schema

```txt
envoy_cluster.json#/properties/local-myapp/properties/healthChecks
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## healthChecks Type

`object` ([healthChecks config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema.md))

# healthChecks Properties

| Property                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                                  |
| :---------------------------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [interval](#interval)                     | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-interval.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/interval")                     |
| [noTrafficInterval](#notrafficinterval)   | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-notrafficinterval.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/noTrafficInterval")   |
| [path](#path)                             | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-path.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/path")                             |
| [scheme](#scheme)                         | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-scheme.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/scheme")                         |
| [timeout](#timeout)                       | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-timeout.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/timeout")                       |
| [unhealthyThreahold](#unhealthythreahold) | `integer` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-unhealthythreahold.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/unhealthyThreahold") |

## interval



`interval`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-interval.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/interval")

### interval Type

`string`

## noTrafficInterval



`noTrafficInterval`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-notrafficinterval.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/noTrafficInterval")

### noTrafficInterval Type

`string`

## path



`path`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-path.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/path")

### path Type

`string`

## scheme



`scheme`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-scheme.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/scheme")

### scheme Type

`string`

## timeout



`timeout`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-timeout.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/timeout")

### timeout Type

`string`

## unhealthyThreahold



`unhealthyThreahold`

* is optional

* Type: `integer`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema-properties-unhealthythreahold.md "envoy_cluster.json#/properties/local-myapp/properties/healthChecks/properties/unhealthyThreahold")

### unhealthyThreahold Type

`integer`
