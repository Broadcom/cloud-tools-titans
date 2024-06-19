# Untitled string in ingress ratelimit config schema Schema

```txt
ratelimit_titanSideCars_ingress.json#/properties/limits/additionalProperties
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                     |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [ratelimit\_titanSideCars\_ingress.json\*](../out/ratelimit_titanSideCars_ingress.json "open original schema") |

## additionalProperties Type

`string`

## additionalProperties Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[1-9]+[0-9]*/(second|minute|hour)$
```

[try pattern](https://regexr.com/?expression=%5E%5B1-9%5D%2B%5B0-9%5D*%2F\(second%7Cminute%7Chour\)%24 "try regular expression with regexr.com")
