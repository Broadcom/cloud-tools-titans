# Untitled integer in envoy cluster config schema Schema

```txt
envoy_cluster.json#/properties/local-myapp/properties/directResponseCode/oneOf/0
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## 0 Type

`integer`

## 0 Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[1-5][0-9]{2}$
```

[try pattern](https://regexr.com/?expression=%5E%5B1-5%5D%5B0-9%5D%7B2%7D%24 "try regular expression with regexr.com")
