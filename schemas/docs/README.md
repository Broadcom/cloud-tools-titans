# README

## Top-level Schemas

* [TitanSideCars config schema](./titansidecars.md "titanSideCars configuration schema") – `titanSideCars.json`

* [cert config schema](./cert.md "titanSideCars") – `cert.json`

* [customer templates config schema](./customtpls.md "titanSideCars") – `customTpls.json`

* [egress config schema](./egress.md "titanSideCars") – `egress.json`

* [egress route config schema](./egress_route.md "titanSideCars") – `egress_route.json`

* [enrich action config schema](./enrich_action.md "\[ingress|egress]") – `enrich_action.json`

* [enrich header match config schema](./enrich_action_match_header.md "\[ingress|egress]") – `enrich_action_match_header.json`

* [enrich transform config schema](./enrich_transform.md "\[ingress|egress]") – `enrich_transform.json`

* [enrichment config schema](./enrichment.md "titanSideCars") – `enrichment.json`

* [envoy cluster config schema](./envoy_cluster.md "titanSideCars") – `envoy_cluster.json`

* [envoy cluster ratelimit config schema](./ratelimit_titansidecars_envoy_clusters.md "titanSideCars") – `ratelimit_titanSideCars_envoy_clusters.json`

* [envoy cluster route config schema](./envoy_cluster_route.md "titanSideCars") – `envoy_cluster_route.json`

* [envoy config schema](./envoy.md "titanSideCars") – `envoy.json`

* [envoy enrichfilter config schema](./envoy_enrichfilter.md "titanSideCars") – `envoy_enrichfilter.json`

* [envoy ratelimit config schema](./ratelimit_titansidecars_envoy.md "titanSideCars") – `ratelimit_titanSideCars_envoy.json`

* [imageRegistry config schema](./imageregistry.md "titanSideCars") – `imageRegistry.json`

* [ingress config schema](./ingress.md "titanSideCars") – `ingress.json`

* [ingress ratelimit config schema](./ratelimit_titansidecars_ingress.md "titanSideCars") – `ratelimit_titanSideCars_ingress.json`

* [ingress route config schema](./ingress_route.md "titanSideCars") – `ingress_route.json`

* [integration config schema](./integration.md "titanSideCars") – `integration.json`

* [issuers config schema](./issuers.md "titanSideCars") – `issuers.json`

* [logs config schema](./logs.md "titanSideCars") – `logs.json`

* [opa config schema](./opa.md "titanSideCars") – `opa.json`

* [ratelimit action match config schema](./ratelimit_action_match.md "ratelimit") – `ratelimit_action_match.json`

* [ratelimit match condition config schema](./ratelimit_match_condition.md "ratelimit match condition") – `ratelimit_match_condition.json`

* [route audit config schema](./route_audit.md "titanSideCars") – `route_audit.json`

* [route config schema](./route_route.md "titanSideCars") – `route_route.json`

* [route enrich config schema](./route_enrich.md "titanSideCars") – `route_enrich.json`

* [route match config schema](./route_match.md "titanSideCars") – `route_match.json`

* [route match header config schema](./route_match_header.md "titanSideCars") – `route_match_header.json`

* [route metrics config schema](./route_metrics.md "titanSideCars") – `route_metrics.json`

* [route ratelimit config schema](./route_ratelimit.md "route") – `route_ratelimit.json`

* [route rbac config schema](./route_rbac.md "titanSideCars") – `route_rbac.json`

* [route rbac police rule config schema](./route_rbac_policy_rule.md "titanSideCars") – `route_rbac_policy_rule.json`

* [route rbac policy config schema](./route_rbac_policy.md "titanSideCars") – `route_rbac_policy.json`

* [titanSideCars ratelimit config schema](./ratelimit_titansidecars.md "titanSideCars") – `ratelimit_titanSideCars.json`

* [validation config schema](./validation.md "titanSideCars") – `validation.json`

* [versionFunction config schema](./versionfunction.md "titanSideCars") – `versionFunction.json`

## Other Schemas

### Objects

* [Ingress ratelimit limit config schema](./ratelimit_titansidecars_ingress-properties-ingress-ratelimit-limit-config-schema.md) – `ratelimit_titanSideCars_ingress.json#/properties/limits`

* [cluster healthChecks config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/healthChecks`

* [cluster retry policy config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-retry-policy-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/retryPolicy`

* [egress workload identity config schema](./egress-properties-egress-workload-identity-config-schema.md) – `egress.json#/properties/workloadIdentity`

* [envoy cluster config schema (except local-myapp)](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+`

* [envoy cpu config schema](./envoy-properties-envoy-cpu-config-schema.md) – `envoy.json#/properties/cpu`

* [envoy custome response filter config schema](./envoy-properties-envoy-custome-response-filter-config-schema.md) – `envoy.json#/properties/customResponsefilter`

* [envoy environment config schema](./envoy-properties-envoy-environment-config-schema.md) – `envoy.json#/properties/env`

* [envoy ephemeral storage config schema](./envoy-properties-envoy-ephemeral-storage-config-schema.md) – `envoy.json#/properties/ephemeralStorage`

* [envoy local circuit breaker config schema](./envoy-properties-envoy-local-circuit-breaker-config-schema.md) – `envoy.json#/properties/localCircuitBreakers`

* [envoy local dynamic configuration from GC config schema](./envoy-properties-envoy-local-dynamic-configuration-from-gc-config-schema.md) – `envoy.json#/properties/loadDynamicConfigurationFromGcs`

* [envoy memory config schema](./envoy-properties-envoy-memory-config-schema.md) – `envoy.json#/properties/memory`

* [envoy per route filter config schema](./envoy-properties-list-of-perroutefilter-envoy-per-route-filter-config-schema.md) – `envoy.json#/properties/perRouteFilters/items`

* [envoy remote circuit breaker config schema](./envoy-properties-envoy-remote-circuit-breaker-config-schema.md) – `envoy.json#/properties/remoteCircuitBreakers`

* [envoy stats raw config schema](./envoy-properties-envoy-stats-raw-config-schema.md) – `envoy.json#/properties/statsConfigRaw`

* [gateway config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-gateway-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/gateway`

* [healthChecks config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-healthchecks-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/healthChecks`

* [healthChecks liveness config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-liveness-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/healthChecks/properties/liveness`

* [healthChecks readyness config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-readyness-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/healthChecks/properties/readyness`

* [healthChecks startup config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-healthchecks-config-schema-properties-healthchecks-startup-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/healthChecks/properties/startup`

* [ingress add header config schema](./ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader-ingress-add-header-config-schema.md) – `ingress_route.json#/properties/customResponse/properties/addHeaders/items`

* [ingress customer response config schema](./ingress_route-properties-ingress-customer-response-config-schema.md) – `ingress_route.json#/properties/customResponse`

* [ingress direct response config schema](./ingress_route-properties-ingress-direct-response-config-schema.md) – `ingress_route.json#/properties/directResponse`

* [ingress workload identity config schema](./ingress-properties-ingress-workload-identity-config-schema.md) – `ingress.json#/properties/workloadIdentity`

* [local-myapp add request headers config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-add-request-headers-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/addRequestHeaders`

* [local-myapp add response headers config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-add-response-headers-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/addResponseHeaders`

* [local-myapp circuit breaker config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-circuit-breaker-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/circuitBreakers`

* [local-myapp config schema](./envoy_cluster-properties-local-myapp-config-schema.md) – `envoy_cluster.json#/properties/local-myapp`

* [local-myapp outlier detection config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-outlier-detection-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/outlierDetection`

* [local-myapp outlier detection config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-local-myapp-outlier-detection-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/outlierDetection`

* [local-myapp remove request headers config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-remove-request-headers-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/removeRequestHeaders`

* [local-myapp remove response headers config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-remove-response-headers-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/removeResponseHeaders`

* [local-myapp retry policy config schema](./envoy_cluster-properties-local-myapp-config-schema-properties-local-myapp-retry-policy-config-schema.md) – `envoy_cluster.json#/properties/local-myapp/properties/retryPolicy`

* [ratelimit cpu config schema](./ratelimit_titansidecars-properties-ratelimit-cpu-config-schema.md) – `ratelimit_titanSideCars.json#/properties/cpu`

* [ratelimit ephemeral storage config schema](./ratelimit_titansidecars-properties-ratelimit-ephemeral-storage-config-schema.md) – `ratelimit_titanSideCars.json#/properties/ephemeralStorage`

* [ratelimit memory config schema](./ratelimit_titansidecars-properties-ratelimit-memory-config-schema.md) – `ratelimit_titanSideCars.json#/properties/memory`

* [route regexRewrite config schema](./route_route-properties-route-regexrewrite-config-schema.md) – `route_route.json#/properties/regexRewrite`

* [route weightedCluster config schema](./route_route-properties-list-of-weightedcluster-route-weightedcluster-config-schema.md) – `route_route.json#/properties/weightedClusters/items`

* [titanSideCars schema](./titansidecars-properties-titansidecars-schema.md) – `titanSideCars.json#/properties/titanSideCars`

### Arrays

* [List of customerResponse addHeader](./ingress_route-properties-ingress-customer-response-config-schema-properties-list-of-customerresponse-addheader.md) – `ingress_route.json#/properties/customResponse/properties/addHeaders`

* [List of egress route](./egress-properties-list-of-egress-route.md) – `egress.json#/properties/routes`

* [List of enrich action](./route_enrich-properties-list-of-enrich-action.md) – `route_enrich.json#/properties/actions`

* [List of enrich action match header](./enrich_action-properties-list-of-enrich-action-match-header.md) – `enrich_action.json#/properties/match_headers`

* [List of enrich parameter](./enrich_transform-properties-list-of-enrich-parameter.md) – `enrich_transform.json#/properties/parameters`

* [List of enrich parameter](./enrich_transform-else-else-then-properties-list-of-enrich-parameter.md) – `enrich_transform.json#/else/else/then/properties/parameters`

* [List of enrich parameter](./enrich_transform-else-else-else-then-properties-list-of-enrich-parameter.md) – `enrich_transform.json#/else/else/else/then/properties/parameters`

* [List of enrichment action](./enrichment-properties-list-of-enrichment-action.md) – `enrichment.json#/properties/actions`

* [List of filters to be disabled](./route_route-properties-list-of-filters-to-be-disabled.md) – `route_route.json#/properties/disableFilters`

* [List of ingress route](./ingress-properties-list-of-ingress-route.md) – `ingress.json#/properties/routes`

* [List of perRouteFilter](./envoy-properties-list-of-perroutefilter.md) – `envoy.json#/properties/perRouteFilters`

* [List of ratelimit action match](./route_ratelimit-properties-list-of-ratelimit-action-match.md) – `route_ratelimit.json#/properties/actions`

* [List of ratelimit match condition](./ratelimit_action_match-properties-list-of-ratelimit-match-condition.md) – `ratelimit_action_match.json#/properties/match`

* [List of rbac policy](./route_rbac-properties-list-of-rbac-policy.md) – `route_rbac.json#/properties/policies`

* [List of rbac policy rule](./route_rbac_policy-properties-list-of-rbac-policy-rule.md) – `route_rbac_policy.json#/properties/rules`

* [List of route match header](./route_match-properties-list-of-route-match-header.md) – `route_match.json#/properties/headers`

* [List of weightedCluster](./route_route-properties-list-of-weightedcluster.md) – `route_route.json#/properties/weightedClusters`

* [Untitled array in ingress config schema](./ingress-properties-additionalroutes.md) – `ingress.json#/properties/additionalRoutes`

* [cluster routes config schema](./envoy_cluster-patternproperties-envoy-cluster-config-schema-except-local-myapp-properties-cluster-routes-config-schema.md) – `envoy_cluster.json#/patternProperties/^(?!local-myapp$)[a-zA-Z_-]+/properties/routes`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-06/schema#`
