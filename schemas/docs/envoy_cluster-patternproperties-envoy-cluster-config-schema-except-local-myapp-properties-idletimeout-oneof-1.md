# Untitled string in envoy cluster config schema Schema

```txt
envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/idleTimeout/oneOf/1
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## 1 Type

`string`

## 1 Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[0-9]+$
```

[try pattern](https://regexr.com/?expression=%5E%5B0-9%5D%2B%24 "try regular expression with regexr.com")
