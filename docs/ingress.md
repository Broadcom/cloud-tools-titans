## Ingress

```yaml
# parent: titanSideCars.ingress

    tokenCheck:     bool
    accessPolicy:   IngressAccessPolicy
    routes:         []IngressRoute
```

### tokenCheck
(bool, default false) Controls token validation. If set to true, token validation is performed on all incoming requests. Token validation can be skipped on a per route basis. If set to false, token validation is skipped by default unless enabled for specific requests on a per route basis.

### accessPolicy
([IngressAccessPolicy](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/routings.md#ingressaccesspolicy), optional) Configures the default access check behaviour for all incoming requests

### routes
([][IngressRoute](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/routings.md#ingressroute), optional)