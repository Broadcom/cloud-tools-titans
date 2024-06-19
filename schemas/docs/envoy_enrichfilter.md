# envoy enrichfilter config schema Schema

```txt
envoy_enrichfilter.json
```

titanSideCars.envoy.enrichfilter

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                        |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [envoy\_enrichfilter.json](../out/envoy_enrichfilter.json "open original schema") |

## envoy enrichfilter config schema Type

`object` ([envoy enrichfilter config schema](envoy_enrichfilter.md))

any of

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-0.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-1.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-2.md "check type definition")

* [Untitled undefined type in envoy enrichfilter config schema](envoy_enrichfilter-anyof-3.md "check type definition")

# envoy enrichfilter config schema Properties

| Property                              | Type     | Required | Nullable       | Defined by                                                                                                                                   |
| :------------------------------------ | :------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------- |
| [allowPrecompiled](#allowprecompiled) | Merged   | Optional | cannot be null | [envoy enrichfilter config schema](envoy_enrichfilter-properties-allowprecompiled.md "envoy_enrichfilter.json#/properties/allowPrecompiled") |
| [failedOpen](#failedopen)             | Merged   | Optional | cannot be null | [envoy enrichfilter config schema](envoy_enrichfilter-properties-failedopen.md "envoy_enrichfilter.json#/properties/failedOpen")             |
| [filename](#filename)                 | `string` | Optional | cannot be null | [envoy enrichfilter config schema](envoy_enrichfilter-properties-filename.md "envoy_enrichfilter.json#/properties/filename")                 |
| [wasmRuntime](#wasmruntime)           | `string` | Optional | cannot be null | [envoy enrichfilter config schema](envoy_enrichfilter-properties-wasmruntime.md "envoy_enrichfilter.json#/properties/wasmRuntime")           |

## allowPrecompiled



`allowPrecompiled`

* is optional

* Type: merged type ([Details](envoy_enrichfilter-properties-allowprecompiled.md))

* cannot be null

* defined in: [envoy enrichfilter config schema](envoy_enrichfilter-properties-allowprecompiled.md "envoy_enrichfilter.json#/properties/allowPrecompiled")

### allowPrecompiled Type

merged type ([Details](envoy_enrichfilter-properties-allowprecompiled.md))

one (and only one) of

* [Untitled boolean in envoy enrichfilter config schema](envoy_enrichfilter-properties-allowprecompiled-oneof-0.md "check type definition")

* [Untitled string in envoy enrichfilter config schema](envoy_enrichfilter-properties-allowprecompiled-oneof-1.md "check type definition")

## failedOpen



`failedOpen`

* is optional

* Type: merged type ([Details](envoy_enrichfilter-properties-failedopen.md))

* cannot be null

* defined in: [envoy enrichfilter config schema](envoy_enrichfilter-properties-failedopen.md "envoy_enrichfilter.json#/properties/failedOpen")

### failedOpen Type

merged type ([Details](envoy_enrichfilter-properties-failedopen.md))

one (and only one) of

* [Untitled boolean in envoy enrichfilter config schema](envoy_enrichfilter-properties-failedopen-oneof-0.md "check type definition")

* [Untitled string in envoy enrichfilter config schema](envoy_enrichfilter-properties-failedopen-oneof-1.md "check type definition")

## filename



`filename`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy enrichfilter config schema](envoy_enrichfilter-properties-filename.md "envoy_enrichfilter.json#/properties/filename")

### filename Type

`string`

## wasmRuntime



`wasmRuntime`

* is optional

* Type: `string`

* cannot be null

* defined in: [envoy enrichfilter config schema](envoy_enrichfilter-properties-wasmruntime.md "envoy_enrichfilter.json#/properties/wasmRuntime")

### wasmRuntime Type

`string`

### wasmRuntime Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value                     | Explanation |
| :------------------------ | :---------- |
| `"envoy.wasm.runtime.v8"` |             |
