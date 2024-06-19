# ratelimit action match config schema Schema

```txt
ratelimit_action_match.json
```

ratelimit.action.match

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ratelimit\_action\_match.json](../out/ratelimit_action_match.json "open original schema") |

## ratelimit action match config schema Type

`object` ([ratelimit action match config schema](ratelimit_action_match.md))

# ratelimit action match config schema Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                                                                                                     |
| :-------------- | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [match](#match) | `array`  | Optional | cannot be null | [ratelimit action match config schema](ratelimit_action_match-properties-list-of-ratelimit-match-condition.md "ratelimit_action_match.json#/properties/match") |
| [limit](#limit) | `string` | Required | cannot be null | [ratelimit action match config schema](ratelimit_action_match-properties-limit.md "ratelimit_action_match.json#/properties/limit")                             |

## match



`match`

* is optional

* Type: `object[]` ([ratelimit match condition config schema](ratelimit_action_match-properties-list-of-ratelimit-match-condition-ratelimit-match-condition-config-schema.md))

* cannot be null

* defined in: [ratelimit action match config schema](ratelimit_action_match-properties-list-of-ratelimit-match-condition.md "ratelimit_action_match.json#/properties/match")

### match Type

`object[]` ([ratelimit match condition config schema](ratelimit_action_match-properties-list-of-ratelimit-match-condition-ratelimit-match-condition-config-schema.md))

## limit



`limit`

* is required

* Type: `string`

* cannot be null

* defined in: [ratelimit action match config schema](ratelimit_action_match-properties-limit.md "ratelimit_action_match.json#/properties/limit")

### limit Type

`string`

### limit Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[^0-9/]+[0-9a-zA-Z_-]*$|^[1-9]+[0-9]*/(second|minute|hour)$
```

[try pattern](https://regexr.com/?expression=%5E%5B%5E0-9%2F%5D%2B%5B0-9a-zA-Z_-%5D*%24%7C%5E%5B1-9%5D%2B%5B0-9%5D*%2F\(second%7Cminute%7Chour\)%24 "try regular expression with regexr.com")
