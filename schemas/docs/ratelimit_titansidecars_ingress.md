# ingress ratelimit config schema Schema

```txt
ratelimit_titanSideCars_ingress.json
```

titanSideCars.ingress.ratelimit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ratelimit\_titanSideCars\_ingress.json](../out/ratelimit_titanSideCars_ingress.json "open original schema") |

## ingress ratelimit config schema Type

`object` ([ingress ratelimit config schema](ratelimit_titansidecars_ingress.md))

# ingress ratelimit config schema Properties

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
