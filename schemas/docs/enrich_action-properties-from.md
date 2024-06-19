# Untitled string in enrich action config schema Schema

```txt
enrich_action.json#/properties/from
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [enrich\_action.json\*](../out/enrich_action.json "open original schema") |

## from Type

`string`

## from Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^(token|header|query)\..+$
```

[try pattern](https://regexr.com/?expression=%5E\(token%7Cheader%7Cquery\)%5C..%2B%24 "try regular expression with regexr.com")
