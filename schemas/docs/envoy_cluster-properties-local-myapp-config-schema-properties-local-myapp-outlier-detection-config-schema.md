# local-myapp outlier detection config schema Schema

```txt
envoy_cluster.json#/properties/local-myapp/properties/outlierDetection
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## outlierDetection Type

`object` ([local-myapp outlier detection config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema.md))

# outlierDetection Properties

| Property                                                                          | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                                               |
| :-------------------------------------------------------------------------------- | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enforcingConsecutive5xx](#enforcingconsecutive5xx)                               | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutive5xx.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutive5xx")                               |
| [enforcingConsecutiveGatewayFailure](#enforcingconsecutivegatewayfailure)         | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutivegatewayfailure.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutiveGatewayFailure")         |
| [enforcingConsecutiveLocalOriginFailure](#enforcingconsecutivelocaloriginfailure) | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutivelocaloriginfailure.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutiveLocalOriginFailure") |
| [enforcingFailurePercentage](#enforcingfailurepercentage)                         | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingfailurepercentage.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingFailurePercentage")                         |
| [enforcingFailurePercentageLocalOrigin](#enforcingfailurepercentagelocalorigin)   | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingfailurepercentagelocalorigin.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingFailurePercentageLocalOrigin")   |
| [enforcingLocalOriginSuccessRate](#enforcinglocaloriginsuccessrate)               | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcinglocaloriginsuccessrate.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingLocalOriginSuccessRate")               |
| [enforcingSuccessRate](#enforcingsuccessrate)                                     | `string`  | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingsuccessrate.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingSuccessRate")                                     |
| [splitExternalLocalOriginErrors](#splitexternallocaloriginerrors)                 | `boolean` | Optional | cannot be null | [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-splitexternallocaloriginerrors.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/splitExternalLocalOriginErrors")                 |

## enforcingConsecutive5xx



`enforcingConsecutive5xx`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutive5xx.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutive5xx")

### enforcingConsecutive5xx Type

`string`

## enforcingConsecutiveGatewayFailure



`enforcingConsecutiveGatewayFailure`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutivegatewayfailure.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutiveGatewayFailure")

### enforcingConsecutiveGatewayFailure Type

`string`

## enforcingConsecutiveLocalOriginFailure



`enforcingConsecutiveLocalOriginFailure`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingconsecutivelocaloriginfailure.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingConsecutiveLocalOriginFailure")

### enforcingConsecutiveLocalOriginFailure Type

`string`

## enforcingFailurePercentage



`enforcingFailurePercentage`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingfailurepercentage.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingFailurePercentage")

### enforcingFailurePercentage Type

`string`

## enforcingFailurePercentageLocalOrigin



`enforcingFailurePercentageLocalOrigin`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingfailurepercentagelocalorigin.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingFailurePercentageLocalOrigin")

### enforcingFailurePercentageLocalOrigin Type

`string`

## enforcingLocalOriginSuccessRate



`enforcingLocalOriginSuccessRate`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcinglocaloriginsuccessrate.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingLocalOriginSuccessRate")

### enforcingLocalOriginSuccessRate Type

`string`

## enforcingSuccessRate



`enforcingSuccessRate`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-enforcingsuccessrate.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/enforcingSuccessRate")

### enforcingSuccessRate Type

`string`

## splitExternalLocalOriginErrors



`splitExternalLocalOriginErrors`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy cluster config schema](envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema-properties-splitexternallocaloriginerrors.md "envoy_cluster.json#/properties/local-myapp/properties/outlierDetection/properties/splitExternalLocalOriginErrors")

### splitExternalLocalOriginErrors Type

`boolean`
