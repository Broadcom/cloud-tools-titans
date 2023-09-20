# Validation framework

## Prerequsite
* docker and docker-compose
  * https://docs.docker.com/compose/install/
* helm
  * https://helm.sh/docs/intro/quickstart/
* gotpl
  * https://github.com/Broadcom/gotpl-titans

## Working directory
* All commands running under the same directory of this **README.md**

## Prepare your test environment
* Copy values.yaml from your service helm chart here
* Create a values-env-override.yaml file to change default images for your test environment
  * See **exmaple of values-env-override.yaml** for detail
* Download the desired umbrella helm chart to this folder

### exmaple of values-env-override.yaml
* add local token generator
* use different images for containers, e.g. envoy, ratelimit
``` yaml
titanSideCars:
  issuers: 
  - issuer: "http://token-generator"
    jwks: http://token-generator/jwks
    cluster: token-generator
    locations:
      fromHeaders:
      - name: ":path"
        valuePrefix: "/oauth2/tokens/"
  envoy:
    clusters:
      token-generator:
        scheme: HTTP
        address: token-generator
        port: 8080
    
  validation:
    environment:
      containers:
        proxy:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/envoy:1.18.3-redhat-fips-titan-proxy-wasm-bundle.20
        ratelimit: 
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/ratelimit:v1.4.0.3-redhat-fips-master.1
        token-generator:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/token-generator:0.0.1
```
## Build test environment and execute tests
* run ./build.sh with required umbrella chart name and chart version, see example command
```bash
./build.sh icds-all-in-one 1.203.48
```
## Advanced topics
* following configuration apply to both **titanSideCars.validation** and **titanSideCars.integration**
### How to write a custom manual local test?
* See sample test cases in values-env-override.yaml
* echo service is used to emulate apps in the manaul local test environment
* The succeed HTTP response will contain entire http request forwarded by envoy proxy after configured enrichment/tranformation.
  * See https://hub.docker.com/r/ealen/echo-server for response format

#### tests list 
* name: Give a meaningful name for the test case
* request: describle HTTP request content
* result: expected response  

##### request object   
| Attribute | Description | Example | Comments | 
| ------- |:----------- |:------- |:-------- |
| address | http request host value | https://proxy:9443 | default to **.environment.ingress.address** | 
| method | http request method value| POST  | | 
| path | http request path value| /tokens  | | 
| headers[] | http request headers| | | 
| headers[].name | header name| Accept | | 
| headers[].value | header value| | application/json | 
| body | request body json object | | |

##### result object   
| Attribute | Description | Example | Comments | 
| ------- |:----------- |:------- |:-------- |
| code | expected http status code | | | 
| code.op | comparison operator | eq | eq, ne, in | 
| code.value | expected http status code | | used for **eq** and **ne** | 
| code.values[] | expected http status code | | used for **in** | 
| body[] | a list of checks on response body |  | | 
| body[].path | jq query format | .host.hostname | See https://jqlang.github.io/jq/ | 
| body[].value | expected value for requested attribute | | | 
| body[].op | supported comparison operators | eq, ne, prefix, suffix, co | | 
```yaml
titanSideCars:
  issuers: 
  - issuer: "http://token-generator"
    jwks: http://token-generator/tokens/jwks
    cluster: token-generator
    locations:
      fromHeaders:
      - name: ":path"
        valuePrefix: "/oauth2/tokens/"
  envoy:
    clusters:
      token-generator:
        scheme: HTTP
        address: token-generator
        port: 8080
    
  validation:
    environment:
      ingress:
        address: "https://proxy:9443"
      containers:
        proxy:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/envoy:1.18.3-redhat-fips-titan-proxy-wasm-bundle.20
        ratelimit: 
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/ratelimit:v1.4.0.3-redhat-fips-master.1
        token-generator:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/token-generator:0.0.1
    tests:
      - name: "Enrich test - header"
        request:
          path: "/identity/v1/authentication"
          method: POST
          headers:
            - name: x-epmp-ratelimit-sp
              value: "anker_test"
          body:
            email: aaa@test.com
            password: ihavenopassword
        result:
          code: 
           value: "200"
          body:
            - path: ".request.headers.x-auth-audit-sp"
              value: "anker_test"
      - name: "RBAC positive test - token"
        request:
          path: "/identity/v3/jobs"
          token:
            scope: system
            privs: "icds:maint:purge"
          headers:
            - name: x-epmp-customer-id
              value: "test_customer"
            - name: x-epmp-domain-id
              value: "test_domain"
        result: 
          code:
            value: "200"
      - name: "RBAC negative test - token"
        request:
          path: "/identity/v3/jobs"
          token:
            scope: system
            privs: "authentication"
          headers:
            - name: x-epmp-customer-id
              value: "test_customer"
            - name: x-epmp-domain-id
              value: "test_domain"
        result: 
          code:
            value: "403"
```
### How to write a custom manual local test?
* See sample integration test cases in values-env-override.yaml
* 
```yaml
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

