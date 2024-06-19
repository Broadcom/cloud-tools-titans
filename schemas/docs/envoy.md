# envoy config schema Schema

```txt
envoy.json
```

titanSideCars.envoy

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                             |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy.json](../out/envoy.json "open original schema") |

## envoy config schema Type

`object` ([envoy config schema](envoy.md))

# envoy config schema Properties

| Property                                                              | Type      | Required | Nullable       | Defined by                                                                                                                                                  |
| :-------------------------------------------------------------------- | :-------- | :------- | :------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [adminPort](#adminport)                                               | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-adminport.md "envoy.json#/properties/adminPort")                                                                     |
| [cdsFolderPath](#cdsfolderpath)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-cdsfolderpath.md "envoy.json#/properties/cdsFolderPath")                                                             |
| [clusters](#clusters)                                                 | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-cluster-config-schema.md "envoy_cluster.json#/properties/clusters")                                            |
| [configFileFolder](#configfilefolder)                                 | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-configfilefolder.md "envoy.json#/properties/configFileFolder")                                                       |
| [configFolder](#configfolder)                                         | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-configfolder.md "envoy.json#/properties/configFolder")                                                               |
| [configVolumeMountPath](#configvolumemountpath)                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-configvolumemountpath.md "envoy.json#/properties/configVolumeMountPath")                                             |
| [connectionDrainDuration](#connectiondrainduration)                   | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-connectiondrainduration.md "envoy.json#/properties/connectionDrainDuration")                                         |
| [cpu](#cpu)                                                           | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-cpu-config-schema.md "envoy.json#/properties/cpu")                                                             |
| [customResponsefilter](#customresponsefilter)                         | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-custome-response-filter-config-schema.md "envoy.json#/properties/customResponsefilter")                        |
| [enrichfilter](#enrichfilter)                                         | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-enrichfilter-config-schema.md "envoy_enrichfilter.json#/properties/enrichfilter")                              |
| [env](#env)                                                           | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-environment-config-schema.md "envoy.json#/properties/env")                                                     |
| [ephemeralStorage](#ephemeralstorage)                                 | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-ephemeral-storage-config-schema.md "envoy.json#/properties/ephemeralStorage")                                  |
| [filtersFolder](#filtersfolder)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-filtersfolder.md "envoy.json#/properties/filtersFolder")                                                             |
| [generateConfigmpForGcs](#generateconfigmpforgcs)                     | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-generateconfigmpforgcs.md "envoy.json#/properties/generateConfigmpForGcs")                                           |
| [healthCheckCriticalLocalSidecars](#healthcheckcriticallocalsidecars) | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-healthcheckcriticallocalsidecars.md "envoy.json#/properties/healthCheckCriticalLocalSidecars")                       |
| [intSecretsFolder](#intsecretsfolder)                                 | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-intsecretsfolder.md "envoy.json#/properties/intSecretsFolder")                                                       |
| [intTlsCert](#inttlscert)                                             | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-inttlscert.md "envoy.json#/properties/intTlsCert")                                                                   |
| [imageName](#imagename)                                               | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-imagename.md "envoy.json#/properties/imageName")                                                                     |
| [imageTag](#imagetag)                                                 | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-imagetag.md "envoy.json#/properties/imageTag")                                                                       |
| [imageRegistry](#imageregistry)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-imageregistry.md "envoy.json#/properties/imageRegistry")                                                             |
| [ldsFolderPath](#ldsfolderpath)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-ldsfolderpath.md "envoy.json#/properties/ldsFolderPath")                                                             |
| [livenessFailureThreshold](#livenessfailurethreshold)                 | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-livenessfailurethreshold.md "envoy.json#/properties/livenessFailureThreshold")                                       |
| [livenessPeriodSeconds](#livenessperiodseconds)                       | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-livenessperiodseconds.md "envoy.json#/properties/livenessPeriodSeconds")                                             |
| [loadDynamicConfigurationFromGcs](#loaddynamicconfigurationfromgcs)   | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-local-dynamic-configuration-from-gc-config-schema.md "envoy.json#/properties/loadDynamicConfigurationFromGcs") |
| [localCircuitBreakers](#localcircuitbreakers)                         | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-local-circuit-breaker-config-schema.md "envoy.json#/properties/localCircuitBreakers")                          |
| [logFolderPath](#logfolderpath)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-logfolderpath.md "envoy.json#/properties/logFolderPath")                                                             |
| [memory](#memory)                                                     | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-memory-config-schema.md "envoy.json#/properties/memory")                                                       |
| [mergeSlashes](#mergeslashes)                                         | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-mergeslashes.md "envoy.json#/properties/mergeSlashes")                                                               |
| [mTLSenabled](#mtlsenabled)                                           | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-mtlsenabled.md "envoy.json#/properties/mTLSenabled")                                                                 |
| [normalizePath](#normalizepath)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-normalizepath.md "envoy.json#/properties/normalizePath")                                                             |
| [pathWithEscapedSlashesAction](#pathwithescapedslashesaction)         | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-pathwithescapedslashesaction.md "envoy.json#/properties/pathWithEscapedSlashesAction")                               |
| [perRouteFilters](#perroutefilters)                                   | `array`   | Optional | cannot be null | [envoy config schema](envoy-properties-list-of-perroutefilter.md "envoy.json#/properties/perRouteFilters")                                                  |
| [ratelimitConfigPath](#ratelimitconfigpath)                           | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-ratelimitconfigpath.md "envoy.json#/properties/ratelimitConfigPath")                                                 |
| [readinessFailureThreshold](#readinessfailurethreshold)               | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-readinessfailurethreshold.md "envoy.json#/properties/readinessFailureThreshold")                                     |
| [readinessPeriodSeconds](#readinessperiodseconds)                     | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-readinessperiodseconds.md "envoy.json#/properties/readinessPeriodSeconds")                                           |
| [remoteCircuitBreakers](#remotecircuitbreakers)                       | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-remote-circuit-breaker-config-schema.md "envoy.json#/properties/remoteCircuitBreakers")                        |
| [secretsFolder](#secretsfolder)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-secretsfolder.md "envoy.json#/properties/secretsFolder")                                                             |
| [scriptsFolder](#scriptsfolder)                                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-scriptsfolder.md "envoy.json#/properties/scriptsFolder")                                                             |
| [startupFailureThreshold](#startupfailurethreshold)                   | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-startupfailurethreshold.md "envoy.json#/properties/startupFailureThreshold")                                         |
| [startupPeriodSeconds](#startupperiodseconds)                         | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-startupperiodseconds.md "envoy.json#/properties/startupPeriodSeconds")                                               |
| [startupTimeoutSeconds](#startuptimeoutseconds)                       | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-startuptimeoutseconds.md "envoy.json#/properties/startupTimeoutSeconds")                                             |
| [statsConfigRaw](#statsconfigraw)                                     | `object`  | Optional | cannot be null | [envoy config schema](envoy-properties-envoy-stats-raw-config-schema.md "envoy.json#/properties/statsConfigRaw")                                            |
| [statsPort](#statsport)                                               | Merged    | Optional | cannot be null | [envoy config schema](envoy-properties-statsport.md "envoy.json#/properties/statsPort")                                                                     |
| [statsFlushInterval](#statsflushinterval)                             | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-statsflushinterval.md "envoy.json#/properties/statsFlushInterval")                                                   |
| [supportPathConfigSource](#supportpathconfigsource)                   | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-supportpathconfigsource.md "envoy.json#/properties/supportPathConfigSource")                                         |
| [tlsCert](#tlscert)                                                   | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-tlscert.md "envoy.json#/properties/tlsCert")                                                                         |
| [trustCACertBundlePath](#trustcacertbundlepath)                       | `string`  | Optional | cannot be null | [envoy config schema](envoy-properties-trustcacertbundlepath.md "envoy.json#/properties/trustCACertBundlePath")                                             |
| [useDynamicConfiguration](#usedynamicconfiguration)                   | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-usedynamicconfiguration.md "envoy.json#/properties/useDynamicConfiguration")                                         |
| [useSeparateConfigMaps](#useseparateconfigmaps)                       | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-useseparateconfigmaps.md "envoy.json#/properties/useSeparateConfigMaps")                                             |
| [useSni](#usesni)                                                     | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-usesni.md "envoy.json#/properties/useSni")                                                                           |
| [validateServerCertificate](#validateservercertificate)               | `boolean` | Optional | cannot be null | [envoy config schema](envoy-properties-validateservercertificate.md "envoy.json#/properties/validateServerCertificate")                                     |

## adminPort



`adminPort`

* is optional

* Type: merged type ([Details](envoy-properties-adminport.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-adminport.md "envoy.json#/properties/adminPort")

### adminPort Type

merged type ([Details](envoy-properties-adminport.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-adminport-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-adminport-oneof-1.md "check type definition")

## cdsFolderPath



`cdsFolderPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-cdsfolderpath.md "envoy.json#/properties/cdsFolderPath")

### cdsFolderPath Type

`string`

## clusters

titanSideCars.envoy.clusters.cluster

`clusters`

* is optional

* Type: `object` ([envoy cluster config schema](envoy-properties-envoy-cluster-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-cluster-config-schema.md "envoy_cluster.json#/properties/clusters")

### clusters Type

`object` ([envoy cluster config schema](envoy-properties-envoy-cluster-config-schema.md))

## configFileFolder



`configFileFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-configfilefolder.md "envoy.json#/properties/configFileFolder")

### configFileFolder Type

`string`

## configFolder



`configFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-configfolder.md "envoy.json#/properties/configFolder")

### configFolder Type

`string`

## configVolumeMountPath



`configVolumeMountPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-configvolumemountpath.md "envoy.json#/properties/configVolumeMountPath")

### configVolumeMountPath Type

`string`

## connectionDrainDuration



`connectionDrainDuration`

* is optional

* Type: merged type ([Details](envoy-properties-connectiondrainduration.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-connectiondrainduration.md "envoy.json#/properties/connectionDrainDuration")

### connectionDrainDuration Type

merged type ([Details](envoy-properties-connectiondrainduration.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-connectiondrainduration-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-connectiondrainduration-oneof-1.md "check type definition")

## cpu



`cpu`

* is optional

* Type: `object` ([envoy cpu config schema](envoy-properties-envoy-cpu-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-cpu-config-schema.md "envoy.json#/properties/cpu")

### cpu Type

`object` ([envoy cpu config schema](envoy-properties-envoy-cpu-config-schema.md))

## customResponsefilter



`customResponsefilter`

* is optional

* Type: `object` ([envoy custome response filter config schema](envoy-properties-envoy-custome-response-filter-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-custome-response-filter-config-schema.md "envoy.json#/properties/customResponsefilter")

### customResponsefilter Type

`object` ([envoy custome response filter config schema](envoy-properties-envoy-custome-response-filter-config-schema.md))

## enrichfilter

titanSideCars.envoy.enrichfilter

`enrichfilter`

* is optional

* Type: `object` ([envoy enrichfilter config schema](envoy-properties-envoy-enrichfilter-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-enrichfilter-config-schema.md "envoy_enrichfilter.json#/properties/enrichfilter")

### enrichfilter Type

`object` ([envoy enrichfilter config schema](envoy-properties-envoy-enrichfilter-config-schema.md))

any of

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-0.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-1.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-2.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-3.md "check type definition")

## env



`env`

* is optional

* Type: `object` ([envoy environment config schema](envoy-properties-envoy-environment-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-environment-config-schema.md "envoy.json#/properties/env")

### env Type

`object` ([envoy environment config schema](envoy-properties-envoy-environment-config-schema.md))

## ephemeralStorage



`ephemeralStorage`

* is optional

* Type: `object` ([envoy ephemeral storage config schema](envoy-properties-envoy-ephemeral-storage-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-ephemeral-storage-config-schema.md "envoy.json#/properties/ephemeralStorage")

### ephemeralStorage Type

`object` ([envoy ephemeral storage config schema](envoy-properties-envoy-ephemeral-storage-config-schema.md))

## filtersFolder



`filtersFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-filtersfolder.md "envoy.json#/properties/filtersFolder")

### filtersFolder Type

`string`

## generateConfigmpForGcs



`generateConfigmpForGcs`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-generateconfigmpforgcs.md "envoy.json#/properties/generateConfigmpForGcs")

### generateConfigmpForGcs Type

`boolean`

## healthCheckCriticalLocalSidecars



`healthCheckCriticalLocalSidecars`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-healthcheckcriticallocalsidecars.md "envoy.json#/properties/healthCheckCriticalLocalSidecars")

### healthCheckCriticalLocalSidecars Type

`boolean`

## intSecretsFolder



`intSecretsFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-intsecretsfolder.md "envoy.json#/properties/intSecretsFolder")

### intSecretsFolder Type

`string`

## intTlsCert



`intTlsCert`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-inttlscert.md "envoy.json#/properties/intTlsCert")

### intTlsCert Type

`string`

## imageName



`imageName`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-imagename.md "envoy.json#/properties/imageName")

### imageName Type

`string`

## imageTag



`imageTag`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-imagetag.md "envoy.json#/properties/imageTag")

### imageTag Type

`string`

## imageRegistry



`imageRegistry`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-imageregistry.md "envoy.json#/properties/imageRegistry")

### imageRegistry Type

`string`

## ldsFolderPath



`ldsFolderPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-ldsfolderpath.md "envoy.json#/properties/ldsFolderPath")

### ldsFolderPath Type

`string`

## livenessFailureThreshold



`livenessFailureThreshold`

* is optional

* Type: merged type ([Details](envoy-properties-livenessfailurethreshold.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-livenessfailurethreshold.md "envoy.json#/properties/livenessFailureThreshold")

### livenessFailureThreshold Type

merged type ([Details](envoy-properties-livenessfailurethreshold.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-livenessfailurethreshold-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-livenessfailurethreshold-oneof-1.md "check type definition")

## livenessPeriodSeconds



`livenessPeriodSeconds`

* is optional

* Type: merged type ([Details](envoy-properties-livenessperiodseconds.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-livenessperiodseconds.md "envoy.json#/properties/livenessPeriodSeconds")

### livenessPeriodSeconds Type

merged type ([Details](envoy-properties-livenessperiodseconds.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-livenessperiodseconds-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-livenessperiodseconds-oneof-1.md "check type definition")

## loadDynamicConfigurationFromGcs



`loadDynamicConfigurationFromGcs`

* is optional

* Type: `object` ([envoy local dynamic configuration from GC config schema](envoy-properties-envoy-local-dynamic-configuration-from-gc-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-local-dynamic-configuration-from-gc-config-schema.md "envoy.json#/properties/loadDynamicConfigurationFromGcs")

### loadDynamicConfigurationFromGcs Type

`object` ([envoy local dynamic configuration from GC config schema](envoy-properties-envoy-local-dynamic-configuration-from-gc-config-schema.md))

## localCircuitBreakers



`localCircuitBreakers`

* is optional

* Type: `object` ([envoy local circuit breaker config schema](envoy-properties-envoy-local-circuit-breaker-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-local-circuit-breaker-config-schema.md "envoy.json#/properties/localCircuitBreakers")

### localCircuitBreakers Type

`object` ([envoy local circuit breaker config schema](envoy-properties-envoy-local-circuit-breaker-config-schema.md))

## logFolderPath



`logFolderPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-logfolderpath.md "envoy.json#/properties/logFolderPath")

### logFolderPath Type

`string`

## memory



`memory`

* is optional

* Type: `object` ([envoy memory config schema](envoy-properties-envoy-memory-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-memory-config-schema.md "envoy.json#/properties/memory")

### memory Type

`object` ([envoy memory config schema](envoy-properties-envoy-memory-config-schema.md))

## mergeSlashes



`mergeSlashes`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-mergeslashes.md "envoy.json#/properties/mergeSlashes")

### mergeSlashes Type

`string`

## mTLSenabled



`mTLSenabled`

* is optional

* Type: merged type ([Details](envoy-properties-mtlsenabled.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-mtlsenabled.md "envoy.json#/properties/mTLSenabled")

### mTLSenabled Type

merged type ([Details](envoy-properties-mtlsenabled.md))

one (and only one) of

* [Untitled boolean in envoy config schema](envoy-properties-mtlsenabled-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-mtlsenabled-oneof-1.md "check type definition")

## normalizePath



`normalizePath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-normalizepath.md "envoy.json#/properties/normalizePath")

### normalizePath Type

`string`

## pathWithEscapedSlashesAction



`pathWithEscapedSlashesAction`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-pathwithescapedslashesaction.md "envoy.json#/properties/pathWithEscapedSlashesAction")

### pathWithEscapedSlashesAction Type

`string`

## perRouteFilters



`perRouteFilters`

* is optional

* Type: `object[]` ([envoy per route filter config schema](envoy-properties-list-of-perroutefilter-envoy-per-route-filter-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-list-of-perroutefilter.md "envoy.json#/properties/perRouteFilters")

### perRouteFilters Type

`object[]` ([envoy per route filter config schema](envoy-properties-list-of-perroutefilter-envoy-per-route-filter-config-schema.md))

## ratelimitConfigPath



`ratelimitConfigPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-ratelimitconfigpath.md "envoy.json#/properties/ratelimitConfigPath")

### ratelimitConfigPath Type

`string`

## readinessFailureThreshold



`readinessFailureThreshold`

* is optional

* Type: merged type ([Details](envoy-properties-readinessfailurethreshold.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-readinessfailurethreshold.md "envoy.json#/properties/readinessFailureThreshold")

### readinessFailureThreshold Type

merged type ([Details](envoy-properties-readinessfailurethreshold.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-readinessfailurethreshold-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-readinessfailurethreshold-oneof-1.md "check type definition")

## readinessPeriodSeconds



`readinessPeriodSeconds`

* is optional

* Type: merged type ([Details](envoy-properties-readinessperiodseconds.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-readinessperiodseconds.md "envoy.json#/properties/readinessPeriodSeconds")

### readinessPeriodSeconds Type

merged type ([Details](envoy-properties-readinessperiodseconds.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-readinessperiodseconds-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-readinessperiodseconds-oneof-1.md "check type definition")

## remoteCircuitBreakers



`remoteCircuitBreakers`

* is optional

* Type: `object` ([envoy remote circuit breaker config schema](envoy-properties-envoy-remote-circuit-breaker-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-remote-circuit-breaker-config-schema.md "envoy.json#/properties/remoteCircuitBreakers")

### remoteCircuitBreakers Type

`object` ([envoy remote circuit breaker config schema](envoy-properties-envoy-remote-circuit-breaker-config-schema.md))

## secretsFolder



`secretsFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-secretsfolder.md "envoy.json#/properties/secretsFolder")

### secretsFolder Type

`string`

## scriptsFolder



`scriptsFolder`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-scriptsfolder.md "envoy.json#/properties/scriptsFolder")

### scriptsFolder Type

`string`

## startupFailureThreshold



`startupFailureThreshold`

* is optional

* Type: merged type ([Details](envoy-properties-startupfailurethreshold.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-startupfailurethreshold.md "envoy.json#/properties/startupFailureThreshold")

### startupFailureThreshold Type

merged type ([Details](envoy-properties-startupfailurethreshold.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-startupfailurethreshold-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-startupfailurethreshold-oneof-1.md "check type definition")

## startupPeriodSeconds



`startupPeriodSeconds`

* is optional

* Type: merged type ([Details](envoy-properties-startupperiodseconds.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-startupperiodseconds.md "envoy.json#/properties/startupPeriodSeconds")

### startupPeriodSeconds Type

merged type ([Details](envoy-properties-startupperiodseconds.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-startupperiodseconds-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-startupperiodseconds-oneof-1.md "check type definition")

## startupTimeoutSeconds



`startupTimeoutSeconds`

* is optional

* Type: merged type ([Details](envoy-properties-startuptimeoutseconds.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-startuptimeoutseconds.md "envoy.json#/properties/startupTimeoutSeconds")

### startupTimeoutSeconds Type

merged type ([Details](envoy-properties-startuptimeoutseconds.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-startuptimeoutseconds-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-startuptimeoutseconds-oneof-1.md "check type definition")

## statsConfigRaw



`statsConfigRaw`

* is optional

* Type: `object` ([envoy stats raw config schema](envoy-properties-envoy-stats-raw-config-schema.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-envoy-stats-raw-config-schema.md "envoy.json#/properties/statsConfigRaw")

### statsConfigRaw Type

`object` ([envoy stats raw config schema](envoy-properties-envoy-stats-raw-config-schema.md))

## statsPort



`statsPort`

* is optional

* Type: merged type ([Details](envoy-properties-statsport.md))

* cannot be null

* defined in: [envoy config schema](envoy-properties-statsport.md "envoy.json#/properties/statsPort")

### statsPort Type

merged type ([Details](envoy-properties-statsport.md))

one (and only one) of

* [Untitled integer in envoy config schema](envoy-properties-statsport-oneof-0.md "check type definition")

* [Untitled string in envoy config schema](envoy-properties-statsport-oneof-1.md "check type definition")

## statsFlushInterval



`statsFlushInterval`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-statsflushinterval.md "envoy.json#/properties/statsFlushInterval")

### statsFlushInterval Type

`string`

## supportPathConfigSource



`supportPathConfigSource`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-supportpathconfigsource.md "envoy.json#/properties/supportPathConfigSource")

### supportPathConfigSource Type

`boolean`

## tlsCert



`tlsCert`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-tlscert.md "envoy.json#/properties/tlsCert")

### tlsCert Type

`string`

## trustCACertBundlePath



`trustCACertBundlePath`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy config schema](envoy-properties-trustcacertbundlepath.md "envoy.json#/properties/trustCACertBundlePath")

### trustCACertBundlePath Type

`string`

## useDynamicConfiguration



`useDynamicConfiguration`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-usedynamicconfiguration.md "envoy.json#/properties/useDynamicConfiguration")

### useDynamicConfiguration Type

`boolean`

## useSeparateConfigMaps



`useSeparateConfigMaps`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-useseparateconfigmaps.md "envoy.json#/properties/useSeparateConfigMaps")

### useSeparateConfigMaps Type

`boolean`

## useSni



`useSni`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-usesni.md "envoy.json#/properties/useSni")

### useSni Type

`boolean`

## validateServerCertificate



`validateServerCertificate`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [envoy config schema](envoy-properties-validateservercertificate.md "envoy.json#/properties/validateServerCertificate")

### validateServerCertificate Type

`boolean`
