# ingress config schema Schema

```txt
ingress.json
```

titanSideCars.ingress

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [ingress.json](../out/ingress.json "open original schema") |

## ingress config schema Type

`object` ([ingress config schema](ingress.md))

# ingress config schema Properties

| Property                              | Type      | Required | Nullable       | Defined by                                                                                                                                  |
| :------------------------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------ |
| [additionalRoutes](#additionalroutes) | `array`   | Optional | cannot be null | [ingress config schema](ingress-properties-additionalroutes.md "ingress.json#/properties/additionalRoutes")                                 |
| [disableAudit](#disableaudit)         | `boolean` | Optional | cannot be null | [ingress config schema](ingress-properties-disableaudit.md "ingress.json#/properties/disableAudit")                                         |
| [disableEnrich](#disableenrich)       | `boolean` | Optional | cannot be null | [ingress config schema](ingress-properties-disableenrich.md "ingress.json#/properties/disableEnrich")                                       |
| [disableRbac](#disablerbac)           | `boolean` | Optional | cannot be null | [ingress config schema](ingress-properties-disablerbac.md "ingress.json#/properties/disableRbac")                                           |
| [enabled](#enabled)                   | `boolean` | Optional | cannot be null | [ingress config schema](ingress-properties-enabled.md "ingress.json#/properties/enabled")                                                   |
| [enrichment](#enrichment)             | `object`  | Optional | cannot be null | [ingress config schema](egress-properties-enrichment-config-schema.md "enrichment.json#/properties/enrichment")                             |
| [ratelimit](#ratelimit)               | `object`  | Optional | cannot be null | [ingress config schema](ingress-properties-ingress-ratelimit-config-schema.md "ratelimit_titanSideCars_ingress.json#/properties/ratelimit") |
| [routes](#routes)                     | `array`   | Optional | cannot be null | [ingress config schema](ingress-properties-list-of-ingress-route.md "ingress.json#/properties/routes")                                      |
| [tokenCheck](#tokencheck)             | `boolean` | Optional | cannot be null | [ingress config schema](ingress-properties-tokencheck.md "ingress.json#/properties/tokenCheck")                                             |
| [workloadIdentity](#workloadidentity) | `object`  | Optional | cannot be null | [ingress config schema](ingress-properties-ingress-workload-identity-config-schema.md "ingress.json#/properties/workloadIdentity")          |

## additionalRoutes



`additionalRoutes`

* is optional

* Type: `object[]` ([ingress route config schema](ingress-properties-additionalroutes-ingress-route-config-schema.md))

* cannot be null

* defined in: [ingress config schema](ingress-properties-additionalroutes.md "ingress.json#/properties/additionalRoutes")

### additionalRoutes Type

`object[]` ([ingress route config schema](ingress-properties-additionalroutes-ingress-route-config-schema.md))

## disableAudit



`disableAudit`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress config schema](ingress-properties-disableaudit.md "ingress.json#/properties/disableAudit")

### disableAudit Type

`boolean`

## disableEnrich



`disableEnrich`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress config schema](ingress-properties-disableenrich.md "ingress.json#/properties/disableEnrich")

### disableEnrich Type

`boolean`

## disableRbac



`disableRbac`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress config schema](ingress-properties-disablerbac.md "ingress.json#/properties/disableRbac")

### disableRbac Type

`boolean`

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress config schema](ingress-properties-enabled.md "ingress.json#/properties/enabled")

### enabled Type

`boolean`

## enrichment

titanSideCars.ingress.enrichment

`enrichment`

* is optional

* Type: `object` ([enrichment config schema](egress-properties-enrichment-config-schema.md))

* cannot be null

* defined in: [ingress config schema](egress-properties-enrichment-config-schema.md "enrichment.json#/properties/enrichment")

### enrichment Type

`object` ([enrichment config schema](egress-properties-enrichment-config-schema.md))

## ratelimit

titanSideCars.ingress.ratelimit

`ratelimit`

* is optional

* Type: `object` ([ingress ratelimit config schema](ingress-properties-ingress-ratelimit-config-schema.md))

* cannot be null

* defined in: [ingress config schema](ingress-properties-ingress-ratelimit-config-schema.md "ratelimit_titanSideCars_ingress.json#/properties/ratelimit")

### ratelimit Type

`object` ([ingress ratelimit config schema](ingress-properties-ingress-ratelimit-config-schema.md))

## routes



`routes`

* is optional

* Type: `object[]` ([ingress route config schema](ingress-properties-additionalroutes-ingress-route-config-schema.md))

* cannot be null

* defined in: [ingress config schema](ingress-properties-list-of-ingress-route.md "ingress.json#/properties/routes")

### routes Type

`object[]` ([ingress route config schema](ingress-properties-additionalroutes-ingress-route-config-schema.md))

## tokenCheck



`tokenCheck`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress config schema](ingress-properties-tokencheck.md "ingress.json#/properties/tokenCheck")

### tokenCheck Type

`boolean`

## workloadIdentity



`workloadIdentity`

* is optional

* Type: `object` ([ingress workload identity config schema](ingress-properties-ingress-workload-identity-config-schema.md))

* cannot be null

* defined in: [ingress config schema](ingress-properties-ingress-workload-identity-config-schema.md "ingress.json#/properties/workloadIdentity")

### workloadIdentity Type

`object` ([ingress workload identity config schema](ingress-properties-ingress-workload-identity-config-schema.md))
