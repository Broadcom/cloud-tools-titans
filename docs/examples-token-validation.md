# Token Validation Examples

### Example 1
Enable by default and disable for specific routes

```yaml
titanSideCars:
  ingress:
    tokenCheck: true
    routes:
    - match:
        prefix: /myapp/status
      tokenCheck: false
```
Above will skip token validation for requests starting with `/myapp/status`

### Example 2
Disable by default and enable for specific routes

```yaml
titanSideCars:
  ingress:
    tokenCheck: false
    routes:
    - match:
        prefix: /myapp/objects
      tokenCheck: true
```
Above will enforce token validation for requests starting with `/myapp/objects`


