## Clusters

```yaml
# parent: itanSideCars.envoy.clusters

    local-myapp:    Cluster
    remote-myapp:   Cluster
    <define your own external cluster>: Cluster
```

### local-myapp
([Cluster](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/cluster.md#cluster))

### remote-myapp
([Cluster](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/cluster.md#cluster))

## Cluster

```yaml
  external:               bool
  port:                   integer
  address:                string
  namespace:              string
  scheme:                 enum
  httpOptions:            HttpOptions
  connectionTimeout:      duration
  healthyPanicThreshold:  integer
  circuitBreakers:        CircuitBreakers
  healthChecks:           HealthChecks
  sniValidation:          bool
```

### port
(integer)

### scheme
(enum) Valid values are

- HTTP: 
- HTTP2: 
- H2C:
- HTTPS:

### httpOptions
([HttpOptions](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/routings.md#httpOptions))

### connectionTimeout
(duration)

### healthyPanicThreshold
(integer)

### circuitBreakers
([CircuitBreakers](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/routings.md#circuitBreakers), optional)

### healthChecks
([HealthChecks](https://github.com/Broadcom/cloud-tools-titans/blob/develop/docs/routings.md#healthchecks))