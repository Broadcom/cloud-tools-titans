## TitanSideCars

```yaml
# parent: titanSideCars

    imageRegistry:    string
    envoy:            Envoy
    opa:              OPA
    ratelimit:        Ratelimit
    ingress:          Ingress
    egress:           Egress
```

### imageRegistry
(string) Common docker image registry path.

### envoy
([Envoy](https://github.com/Broadcom/cloud-tools-titans/blob/master/docs/envoy.md)) Section to enable and configure envoy sidecar	

### opa
([OPA](https://github.com/Broadcom/cloud-tools-titans/blob/master/docs/opa.md)) Section to enable and configure OPA sidecar

### ratelimit
([Ratelimit](https://github.com/Broadcom/cloud-tools-titans/blob/master/docs/ratelimit.md)) Section to enable and configure ratelimit sidecar

### ingress
([Ingress](https://github.com/Broadcom/cloud-tools-titans/blob/master/docs/ingress.md)) Section to configure processing of http inbound requests

### egress
([Egress](https://github.com/Broadcom/cloud-tools-titans/blob/master/docs/egress.md)) Section to configure processing of http outbound requests
