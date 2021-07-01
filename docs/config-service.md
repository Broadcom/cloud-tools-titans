



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