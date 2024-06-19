# Untitled string in route rbac police rule config schema Schema

```txt
route_rbac_policy_rule.json#/properties/rop
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                    |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [route\_rbac\_policy\_rule.json\*](../out/route_rbac_policy_rule.json "open original schema") |

## rop Type

`string`

## rop Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^request[.](body|headers|query|token)\[[a-zA-Z-_]+\]$
```

[try pattern](https://regexr.com/?expression=%5Erequest%5B.%5D\(body%7Cheaders%7Cquery%7Ctoken\)%5C%5B%5Ba-zA-Z-_%5D%2B%5C%5D%24 "try regular expression with regexr.com")
