# envoy cluster config schema Schema

```txt
envoy_cluster.json
```

titanSideCars.envoy.clusters.cluster

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy\_cluster.json](../out/envoy_cluster.json "open original schema") |

## envoy cluster config schema Type

`object` ([envoy cluster config schema](envoy_cluster.md))

# envoy cluster config schema Properties

| Property                       | Type          | Required | Nullable       | Defined by                                                                                                                                                                             |
| :----------------------------- | :------------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [local-myapp](#local-myapp)    | `object`      | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema.md "envoy_cluster.json#/properties/local-myapp")                                                      |
| `^(?!local-myapp$)[a-zA-Z_-]+` | `object`      | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+") |
| `additionalProperties`         | Not specified | Optional | cannot be null | [Untitled schema](undefined.md "undefined#undefined")                                                                                                                                  |

## local-myapp



`local-myapp`

* is optional

* Type: `object` ([local-myapp config schema](envoy_cluster-properties-local-myapp-config-schema.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema.md "envoy_cluster.json#/properties/local-myapp")

### local-myapp Type

`object` ([local-myapp config schema](envoy_cluster-properties-local-myapp-config-schema.md))

## Pattern: `^(?!local-myapp$)[a-zA-Z_-]+`



`^(?!local-myapp$)[a-zA-Z_-]+`

* is optional

* Type: `object` ([envoy cluster config schema (except local-myapp)](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md))

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md "envoy_cluster.json#/patternProperties/^(?!local-myapp$)\[a-zA-Z_-]+")

### ^(?!local-myapp$)\[a-zA-Z\_-]+ Type

`object` ([envoy cluster config schema (except local-myapp)](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md))

## Pattern: `additionalProperties`

no description

`additionalProperties`

* is optional

* Type: unknown

* cannot be null

* defined in: [Untitled schema](undefined.md "undefined#undefined")

### Untitled schema Type

unknown
