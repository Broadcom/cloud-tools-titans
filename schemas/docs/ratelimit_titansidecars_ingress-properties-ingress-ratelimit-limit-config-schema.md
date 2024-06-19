# Ingress ratelimit limit config schema Schema

```txt
ratelimit_titanSideCars_ingress.json#/properties/limits
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [ratelimit\_titanSideCars\_ingress.json\*](../out/ratelimit_titanSideCars_ingress.json "open original schema") |

## limits Type

`object` ([Ingress ratelimit limit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md))

# limits Properties

| Property              | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                 |
| :-------------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Additional Properties | `string` | Optional | cannot be null | [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema-additionalproperties.md "ratelimit_titanSideCars_ingress.json#/properties/limits/additionalProperties") |

## Additional Properties

Additional properties are allowed, as long as they follow this schema:



* is optional

* Type: `string`

* cannot be null

* defined in: [ingress ratelimit config schema](ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema-additionalproperties.md "ratelimit_titanSideCars_ingress.json#/properties/limits/additionalProperties")

### additionalProperties Type

`string`

### additionalProperties Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[1-9]+[0-9]*/(second|minute|hour)$
```

[try pattern](https://regexr.com/?expression=%5E%5B1-9%5D%2B%5B0-9%5D*%2F\(second%7Cminute%7Chour\)%24 "try regular expression with regexr.com")
