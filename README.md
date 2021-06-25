# [Project Titans](https://github.gwd.broadcom.net/SED/titan-mesh-helm-lib-chart)
# Enable Service Mesh On SaaS Natively Without Sweating

## Value Proposition 
- ### Service Mesh has become the de facto layer for SaaS Platform
- ### Cost Saving
  - #### Reduce the developemnt cost of common functionalites
  - #### Reduce the operational cost of running a Control Plane
  - #### Reduce the learning curve barrier to adoption of the service mesh
- ### Managed Security, Visibility and Stability
  - #### End-to-end encryption with auto TLS cert management
  - #### Zero Trust Security built-in
  - #### TLS with FIPS 140-2 compliance
  - #### App's REST API protection with simple configuration
  - #### Configurable App API's operational metrics
  - #### Advanced error handling and global ratelimiting 
- ### Developer friendly 
  - #### Use familiar Helm deployment tool
  - #### Configure desired features in the your own App's Helm Chart


---

## Design Principles
- #### Distributed Architecture
- #### Light weight and high performance
- #### Leverage popular Open Source Tools
- #### Centralized Monitoring
- #### Agile and Incremental Integration

---

## Implementation
> The entire titans solution is delivered using a single helm libary chart to be included into your app's helm chart

## Planned functionalities
| Function | Description | Sidecar
| :------- |:----------- |:-------
| Proxy | Rich uri routing with rewrite capability | Envoy
| | Configurable retries on specific errors |
| | Configurable circuit breaker |
| | TLS 1.2+ communication with auto cert management |
| | Configurable Upstream Health Check to reduce downtime |
| | Configurable Access Logging |
| Authentication | Peer identiy authentication - SNI validation |
| | JWT token validation |
| | Provide OAuth2 authentication for your app with simple configuration |
| Authorization | Enforce authorization check to protect App APIs based on RBAC policy | OPA + Envoy
| | Auto generated RBAC policy from API registration defined in the App helm chart values.yaml |
| Metrics | App API operational metrics with RBAC protection status | + Collectd
| | Easy Dashboad integration, e.g. Grafana, AIOP |
| Global Ratelimit | Global API level ratelimiting | + Ratelimit
| | Easy integration with redis compatible key/value backend, e.g. Google Memorystore |
| Custom functionalities | Unlimited capabilities with Open Standard tool sets | Envoy + OPA + WASM

---
## Deployment
### Step 1: Import libary Helm chart into your app Helm chart
<details>
  <summary>Click to expand!</summary>

    Edit your app's Helm *Chart.yaml* to add library Helm chart as dependency, see example below

  ```yaml
  apiVersion: v2
  name: delta
  version: 1.0.0
  kubeVersion: ">=1.10.0-0"
  description: Helm chart for delta Service
  home: https://github.gwd.broadcom.net/SED/icds-legacy-oidc-client
  sources:
  - https://github.gwd.broadcom.net/SED/icds-legacy-oidc-client
  maintainers: 
  - name: Anker Tsaur
    email: anker_tsaur@broadcom.com
    url: https://github.gwd.broadcom.net/SED/icds-legacy-oidc-client
  dependencies:
  - name: titan-mesh-helm-lib-chart
    version: 1.0.0
    repository: https://artifactory-lvn.broadcom.net/artifactory/sbo-sps-helm-release-local
  ```
</details>

 
### Step 2: Include following template functions into your app Helm chart's kubernetes resource templates
<details>
  <summary>Click to expand!</summary>
  
    Edit your `deployment.yaml` to include `titan-mesh-helm-lib-chart.containers`  function under `spec.template.spec.containers`. See example below

  ```yaml
      containers:
  {{ include "titan-mesh-helm-lib-chart.containers" . | indent 6 }}
  ```

    Include `titan-mesh-helm-lib-chart.volumes` function under `spec.template.spec.volumes`. See example below

  ```yaml
      volumes:
  {{ include "titan-mesh-helm-lib-chart.volumes" . | indent 6 }}
  ```

    Edit your `service.yaml` to include `titan-mesh-helm-lib-chart.ports` function under `spec.ports`. See example below

  ```yaml
  ports:
  {{ include "titan-mesh-helm-lib-chart.ports" . | indent 2 }}
  ```

    Append to your `configmap.yaml` to include `titan-mesh-helm-lib-chart.configmap` function. See example below

  ```yaml
  {{ include "titan-mesh-helm-lib-chart.configmap" . }}
  ```
  #### Note: Cert-Manager Dependency (Optional)
  1. The following step is to use cert-manager to create the kubernetes TLS secret for your app's envoy sidecar. 
      * How to setup cert-manager integration with your namespace is out of this document's scope.
      * The name of required TLS secret will be *<app_service_name>-envoy-tls-cert*, e.g. **tokentool-envoy-tls-cert**. 
      * You can add this kuebrnetes TLS secret into the release namespace without using cert-manager. 

  2. Create a new `certificate.yaml` to include `titan-mesh-helm-lib-chart.ports` function. See example below
  ```yaml
  {{ include "titan-mesh-helm-lib-chart.certificate" . }}
  ```
</details>

### Step 3: Edit values.yaml to enable/configure service mesh funcionalities
---
### Use cases and examples
---
#### **Example 1 - Enable inbound HTTPS requests to my HTTP only application**
<details>
  <summary>Click to expand!</summary>

      * Route all https requests from mesh sidecar's listening port 9443 to your app **delta** on port 8080
      * Setup HTTP heath check path of your app
      * register my application http base path /delta/

  ```yaml
  titanSideCars:
    envoy:
      clusters:
        local-myapp: # reserved keyword
          # Settings of your local application
          port: 8080  
          healthChecks:
            path: /delta/status
        remote-myapp: # reserved keyword
          # Settings of your mesh sidecar proxy
          port: 9443 
        routes: # register your app routing path
        - match:
            prefix: /delta/ 
    ingress:
      enabled:
  ```
</details> 

---
#### **Example 2 - Enable outbound HTTP requests for my app to other service on the service mesh**
<details>
  <summary>Click to expand!</summary>

    In addition to example 1:
      * Route outbound http requests from localhost:9565 for my app to service alpha and beta on the service mesh

  ```yaml
  titanSideCars:
    envoy:
      clusters:
        local-myapp: # reserved keyword
          # Settings of your local application
          port: 8080  
          healthChecks:
            path: /delta/status
        remote-myapp: # reserved keyword
          # Settings of your mesh sidecar proxy
          port: 9443  
        routes: # register your app routing path
        - match:
            prefix: /delta/ 
    ingress:
      enabled:
    egress:
      routes:
      - route: 
          cluster: alpha
      - route: 
          cluster: beta
  ```
</details> 

---
#### **Example 3 - Enable token validation and API path rewrite**
<details>
  <summary>Click to expand!</summary>

    In addition to example 1, 2:
      * Enable token validation for all my API except **/ping/**
      * Rewrite API Path **/v1/delta/** to **/delta/v1/**

  ```yaml
  titanSideCars:
    envoy:
      clusters:
        local-myapp: # reserved keyword
          # Settings of your local application
          port: 8080  
          healthChecks:
            path: /delta/status
        remote-myapp: # reserved keyword
          # Settings of your mesh sidecar proxy
          port: 9443  
        routes: # register your app routing path
        - match:
            prefix: /delta/ 
    ingress:
      tokenCheck: true
      routes:
      - match:
          prefix: /ping/
        tokenCheck: false
      - match:
          prefix: /v1/delta/
        route:
          prefixRewrite: /delta/v1/
    egress:
      routes:
      - route: 
          cluster: alpha
      - route: 
          cluster: beta
  ```
</details> 

---
#### **Example 4 - Enable API metrics and authorization check**
<details>
  <summary>Click to expand!</summary>
  
    In addition to example 1, 2, 3:
      * Enable API metrics on some of my APIs
      * Enable authorization check for **/delta/purge**

  ```yaml
  titanSideCars:
    envoy:
      clusters:
        local-myapp: # reserved keyword
          # Settings of your local application
          port: 8080  
          healthChecks:
            path: /delta/status
        remote-myapp: # reserved keyword
          # Settings of your mesh sidecar proxy
          port: 9443  
        routes: # register your app routing path
        - match:
            prefix: /delta/ 
    ingress:
      tokenCheck: true
      routes:
      - match:
          prefix: /ping/
        tokenCheck: false
      - match:
          prefix: /delta/purge
          method: POST
        metrics:
          name: purge
        accessPolicy:
          oneOf:
          - key: token.sub.scope
            eq: system
          - key: token.sub.scope
            eq: customer 
    egress:
      routes:
      - route: 
          cluster: alpha
      - route: 
          cluster: beta
  ```
</details> 

---
### Step 4: Setup Service Mesh
---
#### Use helm umbrella chart to buld the service mesh with defined secured communiication between services

<details>
  <summary>Click to expand!</summary>

  1. Import each service's values settings into global settings to build the service mesh network automatically 

  ```yaml
  apiVersion: v2
  name: my-umbrella-chart
  version: 1.0.1
  dependencies:
  - delta:
    version: 1.0.0
    import-values:
    - child: titanSideCars.envoy.clusters.remote-myapp
      parent: global.titanSideCars.envoy.clusters.delta 
  - alpha:
    version: 1.0.0
    import-values:
    - child: titanSideCars.envoy.clusters.remote-myapp
      parent: global.titanSideCars.envoy.clusters.alpha 
  - beta:
    version: 2.0.0
    import-values:
    - child: titanSideCars.envoy.clusters.remote-myapp
      parent: global.titanSideCars.envoy.clusters.beta 
  ```

  2. Provide good defaults and enviornment specific settings using the global settings of the values.yaml of the umbrella chart  

  ```yaml
    titanSideCars:
      # provide default values for all services
      logs:
        level: warn
      envoy:
        imageName: envoy-alpine
        imageTag: v1.15.2
        clusters:
          local-myapp: 
            timeout: 61s
          remote-myapp:
            timeout: 62s
      egress:
        port: 9565
  ```
</details>  

---
## Documentaion
### Configuration - incoming

---
## Project Creator
* **Anker Tsaur** - *anker.tsaur@broadcom.com*

## Co-Authors
* **Anker Tsaur** - *anker.tsaur@broadcom.com*
* **Ajit Verma** - *ajit.verma@broadcom.com*
* **Tyler Gray** - *tyler.gray@broadcom.com*

