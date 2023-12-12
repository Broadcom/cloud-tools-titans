# [Project Titans](https://github.com/Broadcom/cloud-tools-titans)
# Enable Service Mesh On SaaS Natively Without Sweating

## Value Proposition 
- ### Service Mesh has become the de facto layer for SaaS Platform
- ### Cost Saving
  - #### Reduce the developemnt cost of common functionalites
  - #### Reduce the operational cost of running a Control Plane
  - #### Reduce the learning curve barrier to adoption of the service mesh
- ### Managed Security, Visibility and Stability
  - #### End-to-end encryption with auto TLS cert management
  - #### TLS with FIPS 140-2 compliance
  - #### App's REST API protection with simple configuration
  - #### Configurable App API's operational metrics
  - #### Advanced error handling and global ratelimiting 
- ### Developer friendly 
  - #### Use familiar Helm deployment tool
  - #### Use kubernetes as the control plane
  - #### Configure desired features in the your own App's Helm Chart

## Implementation
> The entire titans solution is delivered using a single helm libary chart to be included into your app's helm chart

## Supported/Planned functionalities
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
| Gateway only mode | Ingress gateway option | Envoy
| | Deployed as the ingress gateway of the service mesh |
| Support mixed versions | Support mixed titans version in the umbrella deployment model | 
| | Deployed as the ingress gateway of the service mesh |
| Custom functionalities | Unlimited capabilities with Open Standard tool sets | Envoy + OPA + WASM

---

## Build
Build the titan-mesh-helm-lib-chart under cloud-tools-titans directory
```
cd  cloud-tools-titans
sh ./scripts/package.sh
```

## [Documentation](https://github.com/Broadcom/cloud-tools-titans/wiki)

## Reference
* envoy fips build, please see https://github.com/aakatev/envoy-fips

---
## Project Creator
* **Anker Tsaur** - *anker.tsaur@broadcom.com*

## Co-Authors
* **Anker Tsaur** - *anker.tsaur@broadcom.com*
* **Ajit Verma** - *ajit.verma@broadcom.com*
* **Tyler Gray** - *tyler.gray@broadcom.com*

## Contributors
* **Juri Matvejev** - *juri.matvejev@broadcom.com*
