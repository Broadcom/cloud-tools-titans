# titanSideCars schema Schema

```txt
titanSideCars.json#/properties/titanSideCars
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [titanSideCars.json\*](../out/titanSideCars.json "open original schema") |

## titanSideCars Type

`object` ([titanSideCars schema](titansidecars-properties-titansidecars-schema.md))

any of

* [Untitled undefined type in TitanSideCars config schema](titansidecars-properties-titansidecars-schema-anyof-0.md "check type definition")

* [Untitled undefined type in TitanSideCars config schema](titansidecars-properties-titansidecars-schema-anyof-1.md "check type definition")

# titanSideCars Properties

| Property                            | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                     |
| :---------------------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ratelimit](#ratelimit)             | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-titansidecars-ratelimit-config-schema.md "ratelimit_titanSideCars.json#/properties/titanSideCars/properties/ratelimit") |
| [envoy](#envoy)                     | `object` | Required | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-envoy-config-schema.md "envoy.json#/properties/titanSideCars/properties/envoy")                                         |
| [ingress](#ingress)                 | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-ingress-config-schema.md "ingress.json#/properties/titanSideCars/properties/ingress")                                   |
| [egress](#egress)                   | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-egress-config-schema.md "egress.json#/properties/titanSideCars/properties/egress")                                      |
| [cert](#cert)                       | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-cert-config-schema.md "cert.json#/properties/titanSideCars/properties/cert")                                            |
| [customTpls](#customtpls)           | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-customer-templates-config-schema.md "customTpls.json#/properties/titanSideCars/properties/customTpls")                  |
| [issuers](#issuers)                 | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-issuers-config-schema.md "issuers.json#/properties/titanSideCars/properties/issuers")                                   |
| [imageRegistry](#imageregistry)     | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-imageregistry-config-schema.md "imageRegistry.json#/properties/titanSideCars/properties/imageRegistry")                 |
| [versionFunction](#versionfunction) | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-versionfunction-config-schema.md "versionFunction.json#/properties/titanSideCars/properties/versionFunction")           |
| [logs](#logs)                       | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-logs-config-schema.md "logs.json#/properties/titanSideCars/properties/logs")                                            |
| [validation](#validation)           | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-validation-config-schema.md "validation.json#/properties/titanSideCars/properties/validation")                          |
| [opa](#opa)                         | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-opa-config-schema.md "opa.json#/properties/titanSideCars/properties/opa")                                               |
| [integration](#integration)         | `object` | Optional | cannot be null | [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-integration-config-schema.md "integration.json#/properties/titanSideCars/properties/integration")                       |

## ratelimit

titanSideCars.ratelimit

`ratelimit`

* is optional

* Type: `object` ([titanSideCars ratelimit config schema](titansidecars-properties-titansidecars-schema-properties-titansidecars-ratelimit-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-titansidecars-ratelimit-config-schema.md "ratelimit_titanSideCars.json#/properties/titanSideCars/properties/ratelimit")

### ratelimit Type

`object` ([titanSideCars ratelimit config schema](titansidecars-properties-titansidecars-schema-properties-titansidecars-ratelimit-config-schema.md))

## envoy

titanSideCars.envoy

`envoy`

* is required

* Type: `object` ([envoy config schema](titansidecars-properties-titansidecars-schema-properties-envoy-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-envoy-config-schema.md "envoy.json#/properties/titanSideCars/properties/envoy")

### envoy Type

`object` ([envoy config schema](titansidecars-properties-titansidecars-schema-properties-envoy-config-schema.md))

## ingress

titanSideCars.ingress

`ingress`

* is optional

* Type: `object` ([ingress config schema](titansidecars-properties-titansidecars-schema-properties-ingress-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-ingress-config-schema.md "ingress.json#/properties/titanSideCars/properties/ingress")

### ingress Type

`object` ([ingress config schema](titansidecars-properties-titansidecars-schema-properties-ingress-config-schema.md))

## egress

titanSideCars.egress

`egress`

* is optional

* Type: `object` ([egress config schema](titansidecars-properties-titansidecars-schema-properties-egress-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-egress-config-schema.md "egress.json#/properties/titanSideCars/properties/egress")

### egress Type

`object` ([egress config schema](titansidecars-properties-titansidecars-schema-properties-egress-config-schema.md))

## cert

titanSideCars.cert

`cert`

* is optional

* Type: `object` ([cert config schema](titansidecars-properties-titansidecars-schema-properties-cert-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-cert-config-schema.md "cert.json#/properties/titanSideCars/properties/cert")

### cert Type

`object` ([cert config schema](titansidecars-properties-titansidecars-schema-properties-cert-config-schema.md))

## customTpls

titanSideCars.customTpls

`customTpls`

* is optional

* Type: `object` ([customer templates config schema](titansidecars-properties-titansidecars-schema-properties-customer-templates-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-customer-templates-config-schema.md "customTpls.json#/properties/titanSideCars/properties/customTpls")

### customTpls Type

`object` ([customer templates config schema](titansidecars-properties-titansidecars-schema-properties-customer-templates-config-schema.md))

## issuers

titanSideCars.issuers

`issuers`

* is optional

* Type: `object` ([issuers config schema](titansidecars-properties-titansidecars-schema-properties-issuers-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-issuers-config-schema.md "issuers.json#/properties/titanSideCars/properties/issuers")

### issuers Type

`object` ([issuers config schema](titansidecars-properties-titansidecars-schema-properties-issuers-config-schema.md))

## imageRegistry

titanSideCars.imageRegistry

`imageRegistry`

* is optional

* Type: `object` ([imageRegistry config schema](titansidecars-properties-titansidecars-schema-properties-imageregistry-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-imageregistry-config-schema.md "imageRegistry.json#/properties/titanSideCars/properties/imageRegistry")

### imageRegistry Type

`object` ([imageRegistry config schema](titansidecars-properties-titansidecars-schema-properties-imageregistry-config-schema.md))

## versionFunction

titanSideCars.versionFunction

`versionFunction`

* is optional

* Type: `object` ([versionFunction config schema](titansidecars-properties-titansidecars-schema-properties-versionfunction-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-versionfunction-config-schema.md "versionFunction.json#/properties/titanSideCars/properties/versionFunction")

### versionFunction Type

`object` ([versionFunction config schema](titansidecars-properties-titansidecars-schema-properties-versionfunction-config-schema.md))

## logs

titanSideCars.logs

`logs`

* is optional

* Type: `object` ([logs config schema](titansidecars-properties-titansidecars-schema-properties-logs-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-logs-config-schema.md "logs.json#/properties/titanSideCars/properties/logs")

### logs Type

`object` ([logs config schema](titansidecars-properties-titansidecars-schema-properties-logs-config-schema.md))

## validation

titanSideCars.validation

`validation`

* is optional

* Type: `object` ([validation config schema](titansidecars-properties-titansidecars-schema-properties-validation-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-validation-config-schema.md "validation.json#/properties/titanSideCars/properties/validation")

### validation Type

`object` ([validation config schema](titansidecars-properties-titansidecars-schema-properties-validation-config-schema.md))

## opa

titanSideCars.opa

`opa`

* is optional

* Type: `object` ([opa config schema](titansidecars-properties-titansidecars-schema-properties-opa-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-opa-config-schema.md "opa.json#/properties/titanSideCars/properties/opa")

### opa Type

`object` ([opa config schema](titansidecars-properties-titansidecars-schema-properties-opa-config-schema.md))

## integration

titanSideCars.integration

`integration`

* is optional

* Type: `object` ([integration config schema](titansidecars-properties-titansidecars-schema-properties-integration-config-schema.md))

* cannot be null

* defined in: [TitanSideCars config schema](titansidecars-properties-titansidecars-schema-properties-integration-config-schema.md "integration.json#/properties/titanSideCars/properties/integration")

### integration Type

`object` ([integration config schema](titansidecars-properties-titansidecars-schema-properties-integration-config-schema.md))
