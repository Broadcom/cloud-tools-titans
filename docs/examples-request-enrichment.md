# Request Enrichment Examples

Request enrichment can be used to inject additonal headers into the request. Following examples guide through various header injection scenarios.

### Example 1

Inject a header with a static value.

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
      requestEnrichment:
        headers:
        - key: x-my-header  # may also say 'header.x-my-header'. 'header.' is optional as name is always a header
          value: my-value
```

For matching requests, above will inject header `x-my-header` to the request with a value `my-value`. If header `x-my-header` already exists its value will be over-written.

### Example 2

Inject a header with a value from a claim inside the token.

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
      requestEnrichment:
        headers:
        - key: x-token-jti 
          value: token.jti  # 'token.' refers to claims inside token
```
For matching requests, above will inject header `x-token-jti` to the request from `jti` claim in the token. If header `x-token-jti` already exists its value will be over-written.

### Example 3

Inject a header with a value copied from another header.

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
      requestEnrichment:
        headers:
        - key: x-header-sink
          value: header.x-header-source
```
For matching requests, following will add header `x-header-sink` to the request with value coipied from `x-header-source`. If header `x-header-sink` already exists its value will be over-written.

### Example 4

Inject a header only if it does not already exist.

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
      requestEnrichment:
        headers:
        - key: x-header-sink 
          value: header.x-header-source
          retain: true
```
For matching requests, following will add header `x-header-sink` to the request with value coipied from `x-header-source`, but only if `x-header-sink` doesn't already exist. If `x-header-sink` already exists, its original value will be retained. 


### Example 5

Lets see an example of route independent request enrichment

```yaml
titanSideCars:
  ingress:
    requestEnrichment:
      headers:
      - key: x-token-jti
        value: token.jti
```

Above configuration will inject `x-token-jti` header for all requests. This trivial use-case can also be achieved using per route configuration with a match on prefix `/`. <br />
What makes above different is that route independent enrichment can be injected simultaneously into multiple services via global configuration. <br />

For example, instead of adding above config to each service's values file, following config can be added to the global section of shared values file to achieve same effect.

```yaml
global:
  titanSideCars:
    ingress:
      requestEnrichment:
        headers:
        - key: x-token-jti
          value: token.jti
```






