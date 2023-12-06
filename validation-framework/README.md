# Validation framework

## Prerequsite
* docker and docker-compose
  * https://docs.docker.com/compose/install/
* helm
  * https://helm.sh/docs/intro/quickstart/
* gotpl
  * https://github.com/Broadcom/gotpl-titans
* k8split
  * https://github.com/brendanjryan/k8split

## Local testing
* Note: 
  * All commands running under the same directory of this **README.md**

### Prepare your test environment for local 
* Create a values-env-override.yaml file to change default images for your test environment
  * See **exmaple of values-env-override.yaml** below
* Copy values.yaml from the service helm chart which you like to test
* Download the desired umbrella helm chart (in .tgz format) which you like to test your service's mesh configuration against

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
### Command to build the test environment and execute tests locally
* run ./build.sh with required umbrella chart name and chart version, see example command
```bash
./build.sh icds-all-in-one 1.203.48
```

## Advanced topics
* Note: 
  * The following configuration can be applied to both **titanSideCars.validation** and **titanSideCars.integration**
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
## Integration with Kubernetes and Jenkins
* Note
  * In order to run docker contianer with Jenkins agent which is running inside as docker container of Kubernete pod, the build.sh and its dependencies  needs to be running inside a docker container
### Build the image with needed utilities 
* You need the image with both docker daemon and docker cli with docker compose support 
  * official docker image with tag dind, e.g. **docker:rc-dind**
### Example commands
* Start up the prepared build docker image with docker-in-docker support under the required privileged mode
  * docker run --privileged -d -v cloud-tools-titans:/titans -w /titans/validation-framework --name dind-test titan-validation-dind:0.0.1
* Run interactive shell in the running container
  * docker exec -it dind-test /bin/sh
* Perform docker login to gain the access to required docker registry in order to pull required images, e.g.
  * docker login -u {{user name}} -p {{password}} {{docker registry}}
    * e.g. docker login -u demo -p password sbo-sps-docker-release-local.usw1.packages.broadcom.com
* Run build.sh
  * e.g. ./build.sh icds-all-in-one 1.209.46
* Exit and clean up
  * exit
    * to exit from the interative shell of the running container
  * docker stop dind-test
    * Stop the running container by name
  * docker rm dind-test
    * Remove the running container by name
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

