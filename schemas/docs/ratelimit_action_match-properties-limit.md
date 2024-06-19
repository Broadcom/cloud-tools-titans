# Untitled string in ratelimit action match config schema Schema

```txt
ratelimit_action_match.json#/properties/limit
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [ratelimit\_action\_match.json\*](../out/ratelimit_action_match.json "open original schema") |

## limit Type

`string`

## limit Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^0-9/]+[0-9a-zA-Z_-]*$|^[1-9]+[0-9]*/(second|minute|hour)$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E0-9%2F%5D%2B%5B0-9a-zA-Z_-%5D*%24%7C%5E%5B1-9%5D%2B%5B0-9%5D*%2F\(second%7Cminute%7Chour\)%24 "try regular expression with regexr.com")
