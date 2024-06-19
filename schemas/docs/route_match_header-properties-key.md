# Untitled string in route match header config schema Schema

```txt
route_match_header.json#/properties/key
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                           |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [route\_match\_header.json\*](../out/route_match_header.json "open original schema") |

## key Type

`string`

## key Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(:method|:path|:authority|:scheme|:status|(?!:).+)$
```

[try pattern](https://regexr.com/?expression=%5E\(%3Amethod%7C%3Apath%7C%3Aauthority%7C%3Ascheme%7C%3Astatus%7C\(%3F!%3A\).%2B\)%24 "try regular expression with regexr.com")
