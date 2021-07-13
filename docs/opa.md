## OPA
```yaml
# parent: titanSideCars.opa

    enabled:                    bool

    imageRegistry:              string
    imageName:                  string
    imageTag:                   string
    cpu:
      request:                  string
      limit:                    string
    memory:
      request:                  string
      limit:                    string
    ephemeralStorage:
      request:                  string
      limit:                    string
    livenessFailureThreshold:   integer
    readinessFailureThreshold:  integer

    customPolicies:
      tokenSpec:                string
```

### enabled
(bool, default true) Set to false to disable opa sidecar

### imageRegistry
(string, optional) Docker image registry path used for OPA sidecar. Overrides `titanSideCars.imageRegistry`

### imageName
(string, default `opa`)

### imageTag
(string, default `latest`)

### cpu.request
(string, default `250m`)

### cpu.limit
(string, default `1`)

### memory.request
(string, default `256Mi`)

### memory.limit
(string, default `1Gi`)

### ephemeralStorage.request
(string, default `100Mi`)

### ephemeralStorage.limit
(string, default `500Mi`)

### livenessFailureThreshold
(integer, default 50)

### readinessFailureThreshold
(integer, default 100)

### customPolicies.tokenSpec
(string, optional)