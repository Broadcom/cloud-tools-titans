# Untitled string in envoy cluster config schema Schema

```txt
envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/accessibility
```



| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## accessibility Type

`string`

## accessibility Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation |
| :------------- | :---------- |
| `"enterprise"` |             |
| `"public"`     |             |
| `"private"`    |             |
