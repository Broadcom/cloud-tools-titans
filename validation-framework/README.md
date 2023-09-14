# Validation framework

## generate docker-compose.yaml
```bash
gotpl providers/docker-compose-titans.yaml.tpl -f values.yaml -f values-test.yaml > docker-compose.yaml
```
## generate configmap for envoy configuration
```bash
helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml
```

## extract envoy configuration files from configmap
```bash
gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy.yaml" > envoy/envoy.yaml
gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="cds.yaml" > envoy/cds.yaml
gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="lds.yaml" > envoy/lds.yaml
gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="envoy-sds.yaml" > envoy/envoy-sds.yaml
gotpl gomplate/extract_envoy.tpl -f tmp/myapp/templates/configmap.yaml --set select="ratelimit_config.yaml" > envoy/ratelimit/ratelimit_config.yaml
```
## Authors

* **Anker Tsaur** - *anker.tsaur@broadcom.com**

