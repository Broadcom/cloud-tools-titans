# cluster healthChecks config schema Schema

```txt
envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/healthChecks
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## healthChecks Type

`object` ([cluster healthChecks config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md))

# healthChecks Properties

| Property                | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                                                        |
| :---------------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [startup](#startup)     | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-startup-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/startup")     |
| [liveness](#liveness)   | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-liveness-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/liveness")   |
| [readyness](#readyness) | `object` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-readyness-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/readyness") |

## startup



`startup`

* is optional

* Type: `object` ([healthChecks startup config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-startup-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-startup-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/startup")

### startup Type

`object` ([healthChecks startup config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-startup-config-schema.md))

## liveness



`liveness`

* is optional

* Type: `object` ([healthChecks liveness config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-liveness-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-liveness-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/liveness")

### liveness Type

`object` ([healthChecks liveness config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-liveness-config-schema.md))

## readyness



`readyness`

* is optional

* Type: `object` ([healthChecks readyness config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-readyness-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-readyness-config-schema.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+/properties/healthChecks/properties/readyness")

### readyness Type

`object` ([healthChecks readyness config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-readyness-config-schema.md))
