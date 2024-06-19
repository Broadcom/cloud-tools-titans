# ingress add header config schema Schema

```txt
ingress_route.json#/properties/customResponse/properties/addHeaders/items
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [ingress\_route.json\*](../out/ingress_route.json "open original schema") |

## items Type

`object` ([ingress add header config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema.md))

# items Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                      |
| :-------------- | :------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)   | `string` | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema-properties-name.md "ingress_route.json#/properties/customResponse/properties/addHeaders/items/properties/name")   |
| [value](#value) | `string` | Optional | cannot be null | [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema-properties-value.md "ingress_route.json#/properties/customResponse/properties/addHeaders/items/properties/value") |

## name



`name`

* is optional

* Type: `string`

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema-properties-name.md "ingress_route.json#/properties/customResponse/properties/addHeaders/items/properties/name")

### name Type

`string`

## value



`value`

* is optional

* Type: `string`

* cannot be null

* defined in: [ingress route config schema](ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema-properties-value.md "ingress_route.json#/properties/customResponse/properties/addHeaders/items/properties/value")

### value Type

`string`
