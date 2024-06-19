# gateway config schema Schema

```txt
envoy_cluster.json#/properties/local-myapp/properties/gateway
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## gateway Type

`object` ([gateway config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema.md))

# gateway Properties

| Property                                        | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                              |
| :---------------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [checkUpstreamClusters](#checkupstreamclusters) | `boolean` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-checkupstreamclusters.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/checkUpstreamClusters") |
| [defaultBackend](#defaultbackend)               | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-defaultbackend.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/defaultBackend")               |
| [enabled](#enabled)                             | `boolean` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-enabled.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/enabled")                             |
| [minHealthRatio](#minhealthratio)               | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-minhealthratio.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/minHealthRatio")               |
| [port](#port)                                   | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-port.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/port")                                   |

## checkUpstreamClusters



`checkUpstreamClusters`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-checkupstreamclusters.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/checkUpstreamClusters")

### checkUpstreamClusters Type

`boolean`

## defaultBackend



`defaultBackend`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-defaultbackend.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/defaultBackend")

### defaultBackend Type

`string`

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-enabled.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/enabled")

### enabled Type

`boolean`

## minHealthRatio



`minHealthRatio`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-minhealthratio.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/minHealthRatio")

### minHealthRatio Type

`string`

## port



`port`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema-properties-port.md "envoy_cluster.json#/properties/local-myapp/properties/gateway/properties/port")

### port Type

`string`
