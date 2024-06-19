# route config schema Schema

```txt
route_route.json#/properties/route
```

titanSideCars.\[ingress|egress].routes.route

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                              |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [egress\_route.json\*](../out/egress_route.json "open original schema") |

## route Type

`object` ([route config schema](egress_route-properties-route-config-schema.md))

any of

* [Untitled undefined type in route config schema](route_route-anyof-0.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-1.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-2.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-3.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-4.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-5.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-6.md "check type definition")

# route Properties

| Property                              | Type     | Required | Nullable       | Defined by                                                                                                                    |
| :------------------------------------ | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| [autoHostRewrite](#autohostrewrite)   | `string` | Optional | cannot be null | [route config schema](route_route-properties-autohostrewrite.md "route_route.json#/properties/autoHostRewrite")               |
| [cluster](#cluster)                   | `string` | Optional | cannot be null | [route config schema](route_route-properties-cluster.md "route_route.json#/properties/cluster")                               |
| [disableFilters](#disablefilters)     | `array`  | Optional | cannot be null | [route config schema](route_route-properties-list-of-filters-to-be-disabled.md "route_route.json#/properties/disableFilters") |
| [prefixRewrite](#prefixrewrite)       | `string` | Optional | cannot be null | [route config schema](route_route-properties-prefixrewrite.md "route_route.json#/properties/prefixRewrite")                   |
| [regexRewrite](#regexrewrite)         | `object` | Optional | cannot be null | [route config schema](route_route-properties-route-regexrewrite-config-schema.md "route_route.json#/properties/regexRewrite") |
| [timeout](#timeout)                   | `string` | Optional | cannot be null | [route config schema](route_route-properties-timeout.md "route_route.json#/properties/timeout")                               |
| [weightedClusters](#weightedclusters) | `array`  | Optional | cannot be null | [route config schema](route_route-properties-list-of-weightedcluster.md "route_route.json#/properties/weightedClusters")      |

## autoHostRewrite



`autoHostRewrite`

* is optional

* Type: `string`

* cannot be null

* defined in: [route config schema](route_route-properties-autohostrewrite.md "route_route.json#/properties/autoHostRewrite")

### autoHostRewrite Type

`string`

## cluster



`cluster`

* is optional

* Type: `string`

* cannot be null

* defined in: [route config schema](route_route-properties-cluster.md "route_route.json#/properties/cluster")

### cluster Type

`string`

## disableFilters



`disableFilters`

* is optional

* Type: `string[]`

* cannot be null

* defined in: [route config schema](route_route-properties-list-of-filters-to-be-disabled.md "route_route.json#/properties/disableFilters")

### disableFilters Type

`string[]`

## prefixRewrite



`prefixRewrite`

* is optional

* Type: `string`

* cannot be null

* defined in: [route config schema](route_route-properties-prefixrewrite.md "route_route.json#/properties/prefixRewrite")

### prefixRewrite Type

`string`

## regexRewrite



`regexRewrite`

* is optional

* Type: `object` ([route regexRewrite config schema](route_route-properties-route-regexrewrite-config-schema.md))

* cannot be null

* defined in: [route config schema](route_route-properties-route-regexrewrite-config-schema.md "route_route.json#/properties/regexRewrite")

### regexRewrite Type

`object` ([route regexRewrite config schema](route_route-properties-route-regexrewrite-config-schema.md))

## timeout



`timeout`

* is optional

* Type: `string`

* cannot be null

* defined in: [route config schema](route_route-properties-timeout.md "route_route.json#/properties/timeout")

### timeout Type

`string`

## weightedClusters



`weightedClusters`

* is optional

* Type: `object[]` ([route weightedCluster config schema](route_route-properties-list-of-weightedcluster-route-weightedcluster-config-schema.md))

* cannot be null

* defined in: [route config schema](route_route-properties-list-of-weightedcluster.md "route_route.json#/properties/weightedClusters")

### weightedClusters Type

`object[]` ([route weightedCluster config schema](route_route-properties-list-of-weightedcluster-route-weightedcluster-config-schema.md))
