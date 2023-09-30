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
* Copy custome helm template functions to templates folder if your service use custom envoy template for custom envoy filter
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
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/envoy:1.26.1-redhat-fips-titan-proxy-wasm-bundle.22
        ratelimit: 
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/ratelimit:v1.4.0.3-redhat-fips-master.1
        token-generator:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/token-generator:0.205.5
        myapp:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/echo-server:0.8.6
        redis:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/redistimeseries:1.10.5
        engine:
          image: sbo-sps-docker-release-local.usw1.packages.broadcom.com/sps-images/alpine-bash-curl-jq:latest
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
| headers[].value | header value| application/json | |
| body | request body json object | See example below ||

##### result object   
| Attribute | Description | Required | Supported values | Comment | 
| ------- |:----------- |:------- |:-------- |:-------- |
| code | expected http status | Yes | | |
| code.op | comparison operator | No, default to **eq** | eq, ne, in | comma separaye string for **in** | 
| code.value | expected http status code, comma separated string for **in** op code | Yes | stand http status code | e.g. 200 |
| body[] | a list of checks on response body | No | | |
| body[].path | jq query like format | Yes | .attribute, .attribute[], .attribute[].object_attribute | e.g. .host.hostname |
| body[].select | select is used to search element in arrary | No | | |
| body[].select.key | property of object in the array | Yes | jq query dot format  | .name.first |
| body[].select.value | value of selected object| Yes | string | e.q. John | |
| body[].op | supported comparison operators | No, default to **eq** | eq, ne, prefix, suffix, co, pr, npr, has | **has** only applies to the path ending with **[]**|
| body[].value | expected value for requested attribute | Yes | string | |
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
### How to write a custom manual integration test?
* See sample integration test cases in values-env-override.yaml
```yaml
  integration:
    environment:
      ingress:
        address: "https://api.saas.broadcomcloud.com"
    tests:
      - name: "well-known"
        request:
          path: "/.well-known/openid-configuration"
        result:
          code:
            value: "200"
          body:
          - path: ".issuer"
            op: eq
            value: "https://api.saas.broadcomcloud.com"
      - name: "well-known dev-stage"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/.well-known/openid-configuration"
        result:
          code:
            value: "200"
          body:
          - path: ".issuer"
            op: eq
            value: "https://api.saas.broadcomcloud.com"
      - name: "oauth2 keys - find an element in []"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/oauth2/keys"
        result:
          code:
            value: "200"
          body:
          - path: ".keys[].kty"
            select:
              key: .kid
              value: uNj9Ned4QkyR8oOpFCp4_A
            op: eq
            value: RSA
      - name: "well-knows - has"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/.well-known/openid-configuration"
        result:
          code:
            value: "200"
          body:
          - path: ".scopes_supported[]"
            op: has
            value: email
      - name: "well-knows - pr"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/.well-known/openid-configuration"
        result:
          code:
            value: "200"
          body:
          - path: ".scopes_supported"
            op: pr
      - name: "well-knows - npr"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/.well-known/openid-configuration"
        result:
          code:
            value: "200"
          body:
          - path: ".scopes_support"
            op: npr
      - name: "oauth2 keys - pr an attribute of element in []"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/oauth2/keys"
        result:
          code:
            value: "200"
          body:
          - path: ".keys[].kty"
            select:
              key: .kid
              value: uNj9Ned4QkyR8oOpFCp4_A
            op: pr
      - name: "oauth2 keys - pr an attribute of element in []"
        request:
          address: https://api.saas.broadcomcloud.com
          path: "/oauth2/keys"
        result:
          code:
            value: "200"
          body:
          - path: ".keys[].ktb"
            select:
              key: .kid
              value: uNj9Ned4QkyR8oOpFCp4_A
            op: npr
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

