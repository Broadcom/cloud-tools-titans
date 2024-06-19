# egress config schema Schema

```txt
egress.json
```

titanSideCars.egress

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [egress.json](../out/egress.json "open original schema") |

## egress config schema Type

`object` ([egress config schema](egress.md))

# egress config schema Properties

| Property                              | Type      | Required | Nullable       | Defined by                                                                                                                     |
| :------------------------------------ | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| [disableAudit](#disableaudit)         | `boolean` | Optional | cannot be null | [egress config schema](egress-properties-disableaudit.md "egress.json#/properties/disableAudit")                               |
| [disableEnrich](#disableenrich)       | `boolean` | Optional | cannot be null | [egress config schema](egress-properties-disableenrich.md "egress.json#/properties/disableEnrich")                             |
| [enabled](#enabled)                   | `boolean` | Optional | cannot be null | [egress config schema](egress-properties-enabled.md "egress.json#/properties/enabled")                                         |
| [enrichment](#enrichment)             | `object`  | Optional | cannot be null | [egress config schema](egress-properties-enrichment-config-schema.md "enrichment.json#/properties/enrichment")                 |
| [routes](#routes)                     | `array`   | Optional | cannot be null | [egress config schema](egress-properties-list-of-egress-route.md "egress.json#/properties/routes")                             |
| [tokenCheck](#tokencheck)             | `boolean` | Optional | cannot be null | [egress config schema](egress-properties-tokencheck.md "egress.json#/properties/tokenCheck")                                   |
| [workloadIdentity](#workloadidentity) | `object`  | Optional | cannot be null | [egress config schema](egress-properties-egress-workload-identity-config-schema.md "egress.json#/properties/workloadIdentity") |

## disableAudit



`disableAudit`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [egress config schema](egress-properties-disableaudit.md "egress.json#/properties/disableAudit")

### disableAudit Type

`boolean`

## disableEnrich



`disableEnrich`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [egress config schema](egress-properties-disableenrich.md "egress.json#/properties/disableEnrich")

### disableEnrich Type

`boolean`

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [egress config schema](egress-properties-enabled.md "egress.json#/properties/enabled")

### enabled Type

`boolean`

## enrichment

titanSideCars.ingress.enrichment

`enrichment`

* is optional

* Type: `object` ([enrichment config schema](egress-properties-enrichment-config-schema.md))

* cannot be null

* defined in: [egress config schema](egress-properties-enrichment-config-schema.md "enrichment.json#/properties/enrichment")

### enrichment Type

`object` ([enrichment config schema](egress-properties-enrichment-config-schema.md))

## routes



`routes`

* is optional

* Type: `object[]` ([egress route config schema](egress-properties-list-of-egress-route-egress-route-config-schema.md))

* cannot be null

* defined in: [egress config schema](egress-properties-list-of-egress-route.md "egress.json#/properties/routes")

### routes Type

`object[]` ([egress route config schema](egress-properties-list-of-egress-route-egress-route-config-schema.md))

## tokenCheck



`tokenCheck`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [egress config schema](egress-properties-tokencheck.md "egress.json#/properties/tokenCheck")

### tokenCheck Type

`boolean`

## workloadIdentity



`workloadIdentity`

* is optional

* Type: `object` ([egress workload identity config schema](egress-properties-egress-workload-identity-config-schema.md))

* cannot be null

* defined in: [egress config schema](egress-properties-egress-workload-identity-config-schema.md "egress.json#/properties/workloadIdentity")

### workloadIdentity Type

`object` ([egress workload identity config schema](egress-properties-egress-workload-identity-config-schema.md))
