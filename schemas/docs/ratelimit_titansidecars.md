# titanSideCars ratelimit config schema Schema

```txt
ratelimit_titanSideCars.json
```

titanSideCars.ratelimit

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                  |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [ratelimit\_titanSideCars.json](../out/ratelimit_titanSideCars.json "open original schema") |

## titanSideCars ratelimit config schema Type

`object` ([titanSideCars ratelimit config schema](ratelimit_titansidecars.md))

# titanSideCars ratelimit config schema Properties

| Property                                                | Type      | Required | Nullable       | Defined by                                                                                                                                                                           |
| :------------------------------------------------------ | :-------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [enabled](#enabled)                                     | `boolean` | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-enabled.md "ratelimit_titanSideCars.json#/properties/enabled")                                            |
| [monitorByEnvoy](#monitorbyenvoy)                       | `boolean` | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-monitorbyenvoy.md "ratelimit_titanSideCars.json#/properties/monitorByEnvoy")                              |
| [cpu](#cpu)                                             | `object`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-cpu-config-schema.md "ratelimit_titanSideCars.json#/properties/cpu")                            |
| [memory](#memory)                                       | `object`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-memory-config-schema.md "ratelimit_titanSideCars.json#/properties/memory")                      |
| [ephemeralStorage](#ephemeralstorage)                   | `object`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-ephemeral-storage-config-schema.md "ratelimit_titanSideCars.json#/properties/ephemeralStorage") |
| [imageRegistry](#imageregistry)                         | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imageregistry.md "ratelimit_titanSideCars.json#/properties/imageRegistry")                                |
| [configPath](#configpath)                               | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configpath.md "ratelimit_titanSideCars.json#/properties/configPath")                                      |
| [configFileName](#configfilename)                       | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configfilename.md "ratelimit_titanSideCars.json#/properties/configFileName")                              |
| [configVolumeMountPath](#configvolumemountpath)         | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configvolumemountpath.md "ratelimit_titanSideCars.json#/properties/configVolumeMountPath")                |
| [imageName](#imagename)                                 | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imagename.md "ratelimit_titanSideCars.json#/properties/imageName")                                        |
| [imageTag](#imagetag)                                   | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imagetag.md "ratelimit_titanSideCars.json#/properties/imageTag")                                          |
| [runTimeRoot](#runtimeroot)                             | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-runtimeroot.md "ratelimit_titanSideCars.json#/properties/runTimeRoot")                                    |
| [runTimeSubDirectory](#runtimesubdirectory)             | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-runtimesubdirectory.md "ratelimit_titanSideCars.json#/properties/runTimeSubDirectory")                    |
| [log](#log)                                             | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-log.md "ratelimit_titanSideCars.json#/properties/log")                                                    |
| [logLevel](#loglevel)                                   | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-loglevel.md "ratelimit_titanSideCars.json#/properties/logLevel")                                          |
| [redisPoolSize](#redispoolsize)                         | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redispoolsize.md "ratelimit_titanSideCars.json#/properties/redisPoolSize")                                |
| [redisUrl](#redisurl)                                   | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisurl.md "ratelimit_titanSideCars.json#/properties/redisUrl")                                          |
| [redisUseTls](#redisusetls)                             | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisusetls.md "ratelimit_titanSideCars.json#/properties/redisUseTls")                                    |
| [redisSocketType](#redissockettype)                     | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redissockettype.md "ratelimit_titanSideCars.json#/properties/redisSocketType")                            |
| [redisAuth](#redisauth)                                 | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisauth.md "ratelimit_titanSideCars.json#/properties/redisAuth")                                        |
| [userStatsD](#userstatsd)                               | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-userstatsd.md "ratelimit_titanSideCars.json#/properties/userStatsD")                                      |
| [statsdPort](#statsdport)                               | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdport.md "ratelimit_titanSideCars.json#/properties/statsdPort")                                      |
| [statsdProtocol](#statsdprotocol)                       | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdprotocol.md "ratelimit_titanSideCars.json#/properties/statsdProtocol")                              |
| [statsdHost](#statsdhost)                               | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdhost.md "ratelimit_titanSideCars.json#/properties/statsdHost")                                      |
| [nearLimitRatio](#nearlimitratio)                       | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-nearlimitratio.md "ratelimit_titanSideCars.json#/properties/nearLimitRatio")                              |
| [detailedMetricsMode](#detailedmetricsmode)             | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-detailedmetricsmode.md "ratelimit_titanSideCars.json#/properties/detailedMetricsMode")                    |
| [shadowMode](#shadowmode)                               | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-shadowmode.md "ratelimit_titanSideCars.json#/properties/shadowMode")                                      |
| [port](#port)                                           | Merged    | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-port.md "ratelimit_titanSideCars.json#/properties/port")                                                  |
| [healthCheckPath](#healthcheckpath)                     | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckpath.md "ratelimit_titanSideCars.json#/properties/healthCheckPath")                            |
| [healthCheckPort](#healthcheckport)                     | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckport.md "ratelimit_titanSideCars.json#/properties/healthCheckPort")                            |
| [healthCheckScheme](#healthcheckscheme)                 | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckscheme.md "ratelimit_titanSideCars.json#/properties/healthCheckScheme")                        |
| [livenessFailureThreshold](#livenessfailurethreshold)   | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-livenessfailurethreshold.md "ratelimit_titanSideCars.json#/properties/livenessFailureThreshold")          |
| [readinessFailureThreshold](#readinessfailurethreshold) | `string`  | Optional | cannot be null | [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-readinessfailurethreshold.md "ratelimit_titanSideCars.json#/properties/readinessFailureThreshold")        |

## enabled



`enabled`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-enabled.md "ratelimit_titanSideCars.json#/properties/enabled")

### enabled Type

`boolean`

## monitorByEnvoy



`monitorByEnvoy`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-monitorbyenvoy.md "ratelimit_titanSideCars.json#/properties/monitorByEnvoy")

### monitorByEnvoy Type

`boolean`

## cpu



`cpu`

* is optional

* Type: `object` ([ratelimit cpu config schema](ratelimit_titansidecars-properties-ratelimit-cpu-config-schema.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-cpu-config-schema.md "ratelimit_titanSideCars.json#/properties/cpu")

### cpu Type

`object` ([ratelimit cpu config schema](ratelimit_titansidecars-properties-ratelimit-cpu-config-schema.md))

## memory



`memory`

* is optional

* Type: `object` ([ratelimit memory config schema](ratelimit_titansidecars-properties-ratelimit-memory-config-schema.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-memory-config-schema.md "ratelimit_titanSideCars.json#/properties/memory")

### memory Type

`object` ([ratelimit memory config schema](ratelimit_titansidecars-properties-ratelimit-memory-config-schema.md))

## ephemeralStorage



`ephemeralStorage`

* is optional

* Type: `object` ([ratelimit ephemeral storage config schema](ratelimit_titansidecars-properties-ratelimit-ephemeral-storage-config-schema.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-ratelimit-ephemeral-storage-config-schema.md "ratelimit_titanSideCars.json#/properties/ephemeralStorage")

### ephemeralStorage Type

`object` ([ratelimit ephemeral storage config schema](ratelimit_titansidecars-properties-ratelimit-ephemeral-storage-config-schema.md))

## imageRegistry



`imageRegistry`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imageregistry.md "ratelimit_titanSideCars.json#/properties/imageRegistry")

### imageRegistry Type

`string`

## configPath



`configPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configpath.md "ratelimit_titanSideCars.json#/properties/configPath")

### configPath Type

`string`

## configFileName



`configFileName`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configfilename.md "ratelimit_titanSideCars.json#/properties/configFileName")

### configFileName Type

`string`

## configVolumeMountPath



`configVolumeMountPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-configvolumemountpath.md "ratelimit_titanSideCars.json#/properties/configVolumeMountPath")

### configVolumeMountPath Type

`string`

## imageName



`imageName`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imagename.md "ratelimit_titanSideCars.json#/properties/imageName")

### imageName Type

`string`

## imageTag



`imageTag`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-imagetag.md "ratelimit_titanSideCars.json#/properties/imageTag")

### imageTag Type

`string`

## runTimeRoot



`runTimeRoot`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-runtimeroot.md "ratelimit_titanSideCars.json#/properties/runTimeRoot")

### runTimeRoot Type

`string`

## runTimeSubDirectory



`runTimeSubDirectory`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-runtimesubdirectory.md "ratelimit_titanSideCars.json#/properties/runTimeSubDirectory")

### runTimeSubDirectory Type

`string`

## log



`log`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-log.md "ratelimit_titanSideCars.json#/properties/log")

### log Type

`string`

## logLevel



`logLevel`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-loglevel.md "ratelimit_titanSideCars.json#/properties/logLevel")

### logLevel Type

`string`

## redisPoolSize



`redisPoolSize`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-redispoolsize.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redispoolsize.md "ratelimit_titanSideCars.json#/properties/redisPoolSize")

### redisPoolSize Type

merged type ([Details](ratelimit_titansidecars-properties-redispoolsize.md))

one (and only one) of

* [Untitled number in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redispoolsize-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redispoolsize-oneof-1.md "check type definition")

## redisUrl



`redisUrl`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisurl.md "ratelimit_titanSideCars.json#/properties/redisUrl")

### redisUrl Type

`string`

## redisUseTls



`redisUseTls`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-redisusetls.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisusetls.md "ratelimit_titanSideCars.json#/properties/redisUseTls")

### redisUseTls Type

merged type ([Details](ratelimit_titansidecars-properties-redisusetls.md))

one (and only one) of

* [Untitled boolean in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisusetls-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisusetls-oneof-1.md "check type definition")

## redisSocketType



`redisSocketType`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redissockettype.md "ratelimit_titanSideCars.json#/properties/redisSocketType")

### redisSocketType Type

`string`

## redisAuth



`redisAuth`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-redisauth.md "ratelimit_titanSideCars.json#/properties/redisAuth")

### redisAuth Type

`string`

## userStatsD



`userStatsD`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-userstatsd.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-userstatsd.md "ratelimit_titanSideCars.json#/properties/userStatsD")

### userStatsD Type

merged type ([Details](ratelimit_titansidecars-properties-userstatsd.md))

one (and only one) of

* [Untitled boolean in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-userstatsd-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-userstatsd-oneof-1.md "check type definition")

## statsdPort



`statsdPort`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-statsdport.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdport.md "ratelimit_titanSideCars.json#/properties/statsdPort")

### statsdPort Type

merged type ([Details](ratelimit_titansidecars-properties-statsdport.md))

one (and only one) of

* [Untitled number in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdport-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdport-oneof-1.md "check type definition")

## statsdProtocol



`statsdProtocol`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdprotocol.md "ratelimit_titanSideCars.json#/properties/statsdProtocol")

### statsdProtocol Type

`string`

## statsdHost



`statsdHost`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-statsdhost.md "ratelimit_titanSideCars.json#/properties/statsdHost")

### statsdHost Type

`string`

## nearLimitRatio



`nearLimitRatio`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-nearlimitratio.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-nearlimitratio.md "ratelimit_titanSideCars.json#/properties/nearLimitRatio")

### nearLimitRatio Type

merged type ([Details](ratelimit_titansidecars-properties-nearlimitratio.md))

one (and only one) of

* [Untitled number in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-nearlimitratio-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-nearlimitratio-oneof-1.md "check type definition")

## detailedMetricsMode



`detailedMetricsMode`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-detailedmetricsmode.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-detailedmetricsmode.md "ratelimit_titanSideCars.json#/properties/detailedMetricsMode")

### detailedMetricsMode Type

merged type ([Details](ratelimit_titansidecars-properties-detailedmetricsmode.md))

one (and only one) of

* [Untitled boolean in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-detailedmetricsmode-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-detailedmetricsmode-oneof-1.md "check type definition")

## shadowMode



`shadowMode`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-shadowmode.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-shadowmode.md "ratelimit_titanSideCars.json#/properties/shadowMode")

### shadowMode Type

merged type ([Details](ratelimit_titansidecars-properties-shadowmode.md))

one (and only one) of

* [Untitled boolean in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-shadowmode-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-shadowmode-oneof-1.md "check type definition")

## port



`port`

* is optional

* Type: merged type ([Details](ratelimit_titansidecars-properties-port.md))

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-port.md "ratelimit_titanSideCars.json#/properties/port")

### port Type

merged type ([Details](ratelimit_titansidecars-properties-port.md))

one (and only one) of

* [Untitled number in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-port-oneof-0.md "check type definition")

* [Untitled string in titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-port-oneof-1.md "check type definition")

## healthCheckPath



`healthCheckPath`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckpath.md "ratelimit_titanSideCars.json#/properties/healthCheckPath")

### healthCheckPath Type

`string`

## healthCheckPort



`healthCheckPort`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckport.md "ratelimit_titanSideCars.json#/properties/healthCheckPort")

### healthCheckPort Type

`string`

## healthCheckScheme



`healthCheckScheme`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-healthcheckscheme.md "ratelimit_titanSideCars.json#/properties/healthCheckScheme")

### healthCheckScheme Type

`string`

## livenessFailureThreshold



`livenessFailureThreshold`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-livenessfailurethreshold.md "ratelimit_titanSideCars.json#/properties/livenessFailureThreshold")

### livenessFailureThreshold Type

`string`

## readinessFailureThreshold



`readinessFailureThreshold`

* is optional

* Type: `string`

* cannot be null

* defined in: [titanSideCars ratelimit config schema](ratelimit_titansidecars-properties-readinessfailurethreshold.md "ratelimit_titanSideCars.json#/properties/readinessFailureThreshold")

### readinessFailureThreshold Type

`string`
