



## IngressAccessPolicy

```yaml
# titanSideCars.ingress.accessPolicy.

  defaultAction:  enum
```

### defaultAction
(enum, default ALLOW) Valid values are `ALLOW` or `DENY`. 

If defaultAction is set to `ALLOW` then request is allowed by default. The request is denied if it matches one or more access policies defined on a per route basis. <br />
If defaultAction is set to `DENY` then request is denied by default. The request is allowed if it matches one or more access policies defined on a per route basis. <br />
An http status code `403 (Forbidden)` is returned on denial.


**TODO**: Add info regarding processing order 

---

## PerRouteAccessPolicy

```yaml
# titanSideCars.ingress.routes[].accessPolicy.

  enabled:  bool
  name:     string
  oneOf:    []AccessRuleSet  
```

### enabled
(bool, default true) Controls enforecement of supplied access policy

### name
(string, optional) Policy name to enhance readability of generated policy. If not supplied, a unique policy identifier gets auto-generated

### oneOf
([]AccessRuleSet, optional) A list of rulesets that collectively define the access policy for requests that match corresponding route definiton. The route definition is implicitly part of each ruleset. If unspecified, the policy is generated from route defintion alone.

A request a said to `match` the policy if it matches atleast `one-of` the rulesets

---

## AccessRuleSet

```yaml
# titanSideCars.ingress.routes[].accessPolicy.oneOf[].

  allOf: []AccessRule
```

#### allOf
([]AccessRule, required) A set of rules that collectively define an access ruleset.

A request a said to `match` the ruleset if it matches `all-of` the rules in the ruleset

---

## AcessRule

```yaml
# titanSideCars.ingress.routes[].accessPolicy.oneOf[].allOf[].

  key:    string              # left operand

  # operator + right operand
  eq:     string              # equals
  sw:     string              # starts-with
  ew:     string              # ends-with 
  co:     string              # contains
  lk:     string              # like
  pr:     bool                # present (unary)
  neq:    string              # not equals
  nsw:    string              # not starts-with
  new:    string              # not ends-with
  nco:    string              # not contains
  nlk:    string              # not like
  npr:    bool                # not present (unary)
```
An access rule is a simple expression of the form `'left-operand operator right-operand'` and follows standard rules of expression evaluation. The expression is capable of comparing headers, claim from token, json payload attributes, and raw text values.

A header can be referenced via `header.` notaion. Example: *header.x-request-id* <br />
A token claim can be referenced via `token.` notation. Example: *token.sub.scope* or *token.jti* <br />
A payload attribute can be referenced via `payload.` notation. Example: *payload.userType* <br />

If operand has none of the special prefixes, it is treated as raw text

### key
(string, required) Left hand operand. The left operand can be a header, a token claim, or a json payload attribute


### eq | sw | ew | co | lk | pr | neq | nsw | new | nco | nlk | npr
(oneof required oneof) Comparison operator. For binary operators, the operator value indicates the right hand operand.

The supported operators are
- **eq/neq**: Exact string match
- **sw/nsw**: String prefix match
- **ew/new**: String suffix match
- **co/nco**: Substring match
- **lk/nlk**: Regex match. Regex syntax is documented [here](https://github.com/google/re2/wiki/Syntax)
- **pr/npr**: Unary operator. Indicates if key is present or not. Only `true` value is used. Use `pr` to test presence and `npr` to test non presence.

The right hand operand can be a header, a token claim, a json payload attribute, or raw text

---


## RouteMatch

```yaml
  prefix:       string
  regex:        string
  method:       string
  notMethod:    string
  headers:      []HeaderMatch
```

### prefix | regex
(string, optional oneof) Specifies type of match to be performed on url path
- **prefix**: Prefix matching `:path` header. The `:path` header contains entire url path including the query params.
- **regex**: Regex matching entire `:path` header. The regex must constructed to include query parameters. Regex string must adhere to documented [syntax](https://github.com/google/re2/wiki/Syntax)

If neither `prefix` nor `regex` is supplied then match is performed on `/` prefix

### method | notMethod
(string, optional oneof)
- **method**: Request must match supplied value like GET, POST etc. 
- **notMethod**: Request must not match supplied value


### headers
([][HeaderMatch](), optional) List of http headers to match

---

## HeaderMatch

```yaml
  key:    string

  eq:     string              # equals
  sw:     string              # starts-with
  ew:     string              # ends-with 
  co:     string              # contains
  lk:     string              # like
  pr:     bool                # present (unary)
  neq:    string              # not equals
  nsw:    string              # not starts-with
  new:    string              # not ends-with
  nco:    string              # not contains
  nlk:    string              # not like
  npr:    bool                # not present (unary)
```

### key
(string, required) Header name

### eq | sw | ew | co | lk | pr | neq | nsw | new | nco | nlk | npr
(oneof required oneof) Comparison operator. For binary operators, the operator value indicates the right hand operand and should be a raw string. 

The supported operators are
- **eq/neq**: Exact string match
- **sw/nsw**: String prefix match
- **ew/new**: String suffix match
- **co/nco**: Substring match
- **lk/nlk**: Regex match. Regex syntax is documented [here](https://github.com/google/re2/wiki/Syntax)
- **pr/npr**: Unary operator. Indicates if key is present or not. Only `true` value is used. Use `pr` to test presence and `npr` to test non presence.

---