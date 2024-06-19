# ingress route config schema Schema

```txt
ingress_route.json#/properties/additionalRoutes/items
```

titanSideCars.ingress.route

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                   |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ingress.json\*](../out/ingress.json "open original schema") |

## items Type

`object` ([ingress route config schema](ingress-properties-additionalroutes-ingress-route-config-schema.md))

# items Properties

| Property                          | Type      | Required | Nullable       | Defined by                                                                                                                                         |
| :-------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| [audit](#audit)                   | `object`  | Optional | cannot be null | [ingress route config schema](egress_route-properties-route-audit-config-schema.md "route_audit.json#/properties/audit")                           |
| [customResponse](#customresponse) | `object`  | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema.md "ingress_route.json#/properties/customResponse") |
| [directResponse](#directresponse) | `object`  | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema.md "ingress_route.json#/properties/directResponse")   |
| [enrich](#enrich)                 | Merged    | Optional | cannot be null | [ingress route config schema](egress_route-properties-route-enrich-config-schema.md "route_enrich.json#/properties/enrich")                        |
| [match](#match)                   | Merged    | Optional | cannot be null | [ingress route config schema](egress_route-properties-route-match-config-schema.md "route_match.json#/properties/match")                           |
| [metrics](#metrics)               | `object`  | Optional | cannot be null | [ingress route config schema](egress_route-properties-route-metrics-config-schema.md "route_metrics.json#/properties/metrics")                     |
| [ratelimit](#ratelimit)           | `object`  | Optional | cannot be null | [ingress route config schema](ingress_route-properties-route-ratelimit-config-schema.md "route_ratelimit.json#/properties/ratelimit")              |
| [rbac](#rbac)                     | `object`  | Optional | cannot be null | [ingress route config schema](ingress_route-properties-route-rbac-config-schema.md "route_rbac.json#/properties/rbac")                             |
| [route](#route)                   | Merged    | Optional | cannot be null | [ingress route config schema](egress_route-properties-route-config-schema.md "route_route.json#/properties/route")                                 |
| [tokenCheck](#tokencheck)         | `boolean` | Optional | cannot be null | [ingress route config schema](ingress_route-properties-tokencheck.md "ingress_route.json#/properties/tokenCheck")                                  |

## audit

titanSideCars.ingress.route.audit or titanSideCars.egress.route.audit

`audit`

* is optional

* Type: `object` ([route audit config schema](egress_route-properties-route-audit-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](egress_route-properties-route-audit-config-schema.md "route_audit.json#/properties/audit")

### audit Type

`object` ([route audit config schema](egress_route-properties-route-audit-config-schema.md))

## customResponse



`customResponse`

* is optional

* Type: `object` ([ingress customer response config schema](ingress_route-properties-ingress-customer-response-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema.md "ingress_route.json#/properties/customResponse")

### customResponse Type

`object` ([ingress customer response config schema](ingress_route-properties-ingress-customer-response-config-schema.md))

## directResponse



`directResponse`

* is optional

* Type: `object` ([ingress direct response config schema](ingress_route-properties-ingress-direct-response-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema.md "ingress_route.json#/properties/directResponse")

### directResponse Type

`object` ([ingress direct response config schema](ingress_route-properties-ingress-direct-response-config-schema.md))

## enrich

titanSideCars.ingress.route.enrich or titanSideCars.egress.route.enrich

`enrich`

* is optional

* Type: `object` ([route enrich config schema](egress_route-properties-route-enrich-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](egress_route-properties-route-enrich-config-schema.md "route_enrich.json#/properties/enrich")

### enrich Type

`object` ([route enrich config schema](egress_route-properties-route-enrich-config-schema.md))

any of

* [Untitled undefined type in route enrich config schema](route_enrich-anyof-0.md "check type definition")

* [Untitled undefined type in route enrich config schema](route_enrich-anyof-1.md "check type definition")

## match

titanSideCars.\[ingress|egress|envoy.cluster].route.match

`match`

* is optional

* Type: `object` ([route match config schema](egress_route-properties-route-match-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](egress_route-properties-route-match-config-schema.md "route_match.json#/properties/match")

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

## metrics

titanSideCars.ingress.route.metrics or titanSideCars.egress.route.metrics

`metrics`

* is optional

* Type: `object` ([route metrics config schema](egress_route-properties-route-metrics-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](egress_route-properties-route-metrics-config-schema.md "route_metrics.json#/properties/metrics")

### metrics Type

`object` ([route metrics config schema](egress_route-properties-route-metrics-config-schema.md))

## ratelimit

route.ratelimit

`ratelimit`

* is optional

* Type: `object` ([route ratelimit config schema](ingress_route-properties-route-ratelimit-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-route-ratelimit-config-schema.md "route_ratelimit.json#/properties/ratelimit")

### ratelimit Type

`object` ([route ratelimit config schema](ingress_route-properties-route-ratelimit-config-schema.md))

## rbac

titanSideCars.ingress.route.rbac or titanSideCars.egress.route.rbac

`rbac`

* is optional

* Type: `object` ([route rbac config schema](ingress_route-properties-route-rbac-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-route-rbac-config-schema.md "route_rbac.json#/properties/rbac")

### rbac Type

`object` ([route rbac config schema](ingress_route-properties-route-rbac-config-schema.md))

## route

titanSideCars.\[ingress|egress].routes.route

`route`

* is optional

* Type: `object` ([route config schema](egress_route-properties-route-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](egress_route-properties-route-config-schema.md "route_route.json#/properties/route")

### route Type

`object` ([route config schema](egress_route-properties-route-config-schema.md))

any of

* [Untitled undefined type in route config schema](route_route-anyof-0.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-1.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-2.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-3.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-4.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-5.md "check type definition")

* [Untitled undefined type in route config schema](route_route-anyof-6.md "check type definition")

## tokenCheck



`tokenCheck`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-tokencheck.md "ingress_route.json#/properties/tokenCheck")

### tokenCheck Type

`boolean`
