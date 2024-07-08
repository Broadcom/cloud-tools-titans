# envoy cluster config schema (except local-myapp) Schema

```txt
envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## ^(?!local-myapp$)\[a-zA-Z\_-]+ Type

`object` ([envoy cluster config schema (except local-myapp)](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md))

# ^(?!local-myapp$)\[a-zA-Z\_-]+ Properties

| Property                                        | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                |
| :---------------------------------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [accessibility](#accessibility)                 | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-accessibility.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/accessibility")                                  |
| [address](#address)                             | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-address.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/address")                                              |
| [alias](#alias)                                 | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-alias.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/alias")                                                  |
| [connectionTimeout](#connectiontimeout)         | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-connectiontimeout.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/connectionTimeout")                          |
| [healthChecks](#healthchecks)                   | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks")              |
| [healthyPanicThreshold](#healthypanicthreshold) | Merged   | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthyPanicThreshold")                  |
| [hostname](#hostname)                           | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-hostname.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/hostname")                                            |
| [idleTimeout](#idletimeout)                     | Merged   | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/idleTimeout")                                      |
| [lbPolicy](#lbpolicy)                           | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-lbpolicy.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/lbPolicy")                                            |
| [outlierDetection](#outlierdetection)           | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-local-myapp-outlier-detection-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/outlierDetection") |
| [path](#path)                                   | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-path.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/path")                                                    |
| [port](#port)                                   | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-port.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/port")                                                    |
| [retryPolicy](#retrypolicy)                     | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-retry-policy-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/retryPolicy")               |
| [routes](#routes)                               | `array`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/routes")                          |
| [scheme](#scheme)                               | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-scheme.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/scheme")                                                |
| [targetPort](#targetport)                       | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-targetport.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/targetPort")                                        |
| [type](#type)                                   | `string` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-type.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/type")                                                    |

## accessibility



`accessibility`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-accessibility.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/accessibility")

### accessibility Type

`string`

### accessibility Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation |
| :------------- | :---------- |
| `"enterprise"` |             |
| `"public"`     |             |
| `"private"`    |             |

## address



`address`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-address.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/address")

### address Type

`string`

## alias



`alias`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-alias.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/alias")

### alias Type

`string`

## connectionTimeout



`connectionTimeout`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-connectiontimeout.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/connectionTimeout")

### connectionTimeout Type

`string`

## healthChecks



`healthChecks`

* is optional

* Type: `object` ([cluster healthChecks config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks")

### healthChecks Type

`object` ([cluster healthChecks config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md))

## healthyPanicThreshold



`healthyPanicThreshold`

* is optional

* Type: merged type ([Details](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthyPanicThreshold")

### healthyPanicThreshold Type

merged type ([Details](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold.md))

one (and only one) of

* [Untitled integer in envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold-oneof-0.md "check type definition")

* [Untitled string in envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-healthypanicthreshold-oneof-1.md "check type definition")

## hostname



`hostname`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-hostname.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/hostname")

### hostname Type

`string`

## idleTimeout



`idleTimeout`

* is optional

* Type: merged type ([Details](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/idleTimeout")

### idleTimeout Type

merged type ([Details](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout.md))

one (and only one) of

* [Untitled integer in envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout-oneof-0.md "check type definition")

* [Untitled string in envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-idletimeout-oneof-1.md "check type definition")

## lbPolicy



`lbPolicy`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-lbpolicy.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/lbPolicy")

### lbPolicy Type

`string`

## outlierDetection



`outlierDetection`

* is optional

* Type: `object` ([local-myapp outlier detection config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-local-myapp-outlier-detection-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-local-myapp-outlier-detection-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/outlierDetection")

### outlierDetection Type

`object` ([local-myapp outlier detection config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-local-myapp-outlier-detection-config-schema.md))

## path



`path`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-path.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/path")

### path Type

`string`

## port



`port`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-port.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/port")

### port Type

`string`

## retryPolicy



`retryPolicy`

* is optional

* Type: `object` ([cluster retry policy config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-retry-policy-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-retry-policy-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/retryPolicy")

### retryPolicy Type

`object` ([cluster retry policy config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-retry-policy-config-schema.md))

## routes



`routes`

* is optional

* Type: `object[]` ([envoy cluster route config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema-envoy-cluster-route-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/routes")

### routes Type

`object[]` ([envoy cluster route config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema-envoy-cluster-route-config-schema.md))

## scheme



`scheme`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-scheme.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/scheme")

### scheme Type

`string`

## targetPort



`targetPort`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-targetport.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/targetPort")

### targetPort Type

`string`

## type



`type`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-type.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/type")

### type Type

`string`
