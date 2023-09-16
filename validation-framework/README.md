# Validation framework

## Prerequsite
* docker-compose
  * https://docs.docker.com/compose/install/
* helm
  * https://helm.sh/docs/intro/quickstart/
* gotpl
  * https://github.com/Broadcom/gotpl-titans

## Working directory
* All commands running under the same directory of this **README.md**

## Prepare your test environment
* Copy values.yaml from your service helm chart here
* Modify values-test.yaml to change default images for your test environment
* Download the desired umbrella helm chart here
* Create the *values-env-override.yaml* to override default open source containers' images

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
## Build test environment
* run ./build.sh with required umbrella chart name and chart version, see example command
```bash
./build.sh icds-all-in-one 1.203.48
```

## Run it up
```bash
docker-compose up
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

