# ingress ratelimit config schema Schema

```txt
ratelimit_titanSideCars_ingress.json#/properties/ratelimit
```

titanSideCars.ingress.ratelimit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ingress.json\*](../out/ingress.json "open original schema") |

## ratelimit Type

`object` ([ingress ratelimit config schema](ingress-properties-ingress-ratelimit-config-schema.md))

# ratelimit Properties

| Property            | Type      | Required | Nullable       | Defined by                                                                                                                                                                       |
| :------------------ | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled) | `boolean` | Optional | cannot be null | [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-enabled.md "ratelimit_titanSideCars_ingress.json#/properties/enabled")                              |
| [limits](#limits)   | `object`  | Optional | cannot be null | [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md "ratelimit_titanSideCars_ingress.json#/properties/limits") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-enabled.md "ratelimit_titanSideCars_ingress.json#/properties/enabled")

### enabled Type

`boolean`

## limits



`limits`

* is optional

* Type: `object` ([Ingress ratelimit limit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md))

* cannot be null

* defined in: [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md "ratelimit_titanSideCars_ingress.json#/properties/limits")

### limits Type

`object` ([Ingress ratelimit limit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md))
