# Untitled string in route match config schema Schema

```txt
route_match.json#/properties/prefix
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                            |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [route\_match.json\*](../out/route_match.json "open original schema") |

## prefix Type

`string`

## prefix Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^/([a-zA-Z0-9_\-.]+/?)*$
```

[try pattern](https://regexr.com/?expression=%5E%2F\(%5Ba-zA-Z0-9_%5C-.%5D%2B%2F%3F\)*%24 "try regular expression with regexr.com")
