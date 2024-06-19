# ingress customer response config schema Schema

```txt
ingress_route.json#/properties/customResponse
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [ingress\_route.json\*](../out/ingress_route.json "open original schema") |

## customResponse Type

`object` ([ingress customer response config schema](ingress_route-properties-ingress-customer-response-config-schema.md))

# customResponse Properties

| Property                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                             |
| :------------------------ | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)       | `boolean` | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-enabled.md "ingress_route.json#/properties/customResponse/properties/enabled")                               |
| [addHeaders](#addheaders) | `array`   | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader.md "ingress_route.json#/properties/customResponse/properties/addHeaders") |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-enabled.md "ingress_route.json#/properties/customResponse/properties/enabled")

### enabled Type

`boolean`

## addHeaders



`addHeaders`

* is optional

* Type: `object[]` ([ingress add header config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema.md))

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader.md "ingress_route.json#/properties/customResponse/properties/addHeaders")

### addHeaders Type

`object[]` ([ingress add header config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema.md))
