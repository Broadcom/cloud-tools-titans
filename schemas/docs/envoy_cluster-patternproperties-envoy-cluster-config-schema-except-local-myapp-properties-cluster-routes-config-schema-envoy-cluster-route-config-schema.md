# envoy cluster route config schema Schema

```txt
envoy_cluster_route.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/routes/items
```

titanSideCars.envoy.clusters.cluster.routes.route

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy\_cluster.json\*](../out/envoy_cluster.json "open original schema") |

## items Type

`object` ([envoy cluster route config schema](envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema-envoy-cluster-route-config-schema.md))

# items Properties

| Property                        | Type     | Required | Nullable       | Defined by                                                                                                                                |
| :------------------------------ | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| [match](#match)                 | Merged   | Required | cannot be null | [envoy cluster route config schema](egress_route-properties-route-match-config-schema.md "route_match.json#/properties/match")            |
| [accessibility](#accessibility) | `string` | Optional | cannot be null | [envoy cluster route config schema](envoy_cluster_route-properties-accessibility.md "envoy_cluster_route.json#/properties/accessibility") |

## match

titanSideCars.\[ingress|egress|envoy.cluster].route.match

`match`

* is required

* Type: `object` ([route match config schema](egress_route-properties-route-match-config-schema.md))

* cannot be null

* defined in: [envoy cluster route config schema](egress_route-properties-route-match-config-schema.md "route_match.json#/properties/match")

### match Type

`object` ([route match config schema](egress_route-properties-route-match-config-schema.md))

one (and only one) of

* [Untitled undefined type in route match config schema](route_match-oneof-0.md "check type definition")

* [Untitled undefined type in route match config schema](route_match-oneof-1.md "check type definition")

* [Untitled undefined type in route match config schema](route_match-oneof-2.md "check type definition")

* not

  * any of

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-0.md "check type definition")

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-1.md "check type definition")

    * [Untitled undefined type in route match config schema](route_match-oneof-3-not-anyof-2.md "check type definition")

## accessibility



`accessibility`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy cluster route config schema](envoy_cluster_route-properties-accessibility.md "envoy_cluster_route.json#/properties/accessibility")

### accessibility Type

`string`

### accessibility Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation |
| :------------- | :---------- |
| `"enterprise"` |             |
| `"public"`     |             |
| `"private"`    |             |
