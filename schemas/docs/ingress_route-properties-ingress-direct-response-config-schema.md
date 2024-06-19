# ingress direct response config schema Schema

```txt
ingress_route.json#/properties/directResponse
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ingress\_route.json\*](../out/ingress_route.json "open original schema") |

## directResponse Type

`object` ([ingress direct response config schema](ingress_route-properties-ingress-direct-response-config-schema.md))

# directResponse Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                                           |
| :---------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [body](#body)     | `string` | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-body.md "ingress_route.json#/properties/directResponse/properties/body")     |
| [status](#status) | Merged   | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-status.md "ingress_route.json#/properties/directResponse/properties/status") |

## body



`body`

* is optional

* Type: `string`

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-body.md "ingress_route.json#/properties/directResponse/properties/body")

### body Type

`string`

## status



`status`

* is optional

* Type: merged type ([Details](ingress_route-properties-ingress-direct-response-config-schema-properties-status.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-status.md "ingress_route.json#/properties/directResponse/properties/status")

### status Type

merged type ([Details](ingress_route-properties-ingress-direct-response-config-schema-properties-status.md))

one (and only one) of

* [Untitled integer in ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-status-oneof-0.md "check type definition")

* [Untitled string in ingress route config schema](ingress_route-properties-ingress-direct-response-config-schema-properties-status-oneof-1.md "check type definition")
