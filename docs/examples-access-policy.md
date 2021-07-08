# Access Policy Examples

### Example 1

Lets look at a policy where default action is to deny a request unless explicity allowed by a matching access policy

```yaml
titanSideCars:
  ingress:
    accessPolicy:
      defaultAction: DENY
    routes:
    - match:  /myapp/objects
      method: POST
      accessPolicy:
        oneOf:
        - allOf:
          - key: token.priv
            eq: create_object
    - match:  /myapp/objects
      method: GET
      accessPolicy:
      - allOf:
        - key: token.priv
          eq: read_object  
```

With above policy config, a `GET /myapp/objects` request wil be allowed if the `priv` claim in token equals `read_object`. Also, a `POST /myapp/objects` request will be allowed if the `priv` claim in token equals `create_object`. All other requests will be denied with a http 403 response code



### Example 2

Lets look at a policy where default action is to allow a request unless explicity denied by a matching access policy

```yaml
titanSideCars:
  ingress:
    accessPolicy:
      defaultAction: ALLOW
    routes:
    - match:  /myapp/objects
      method: POST
      accessPolicy:
        oneOf:
        - allOf:
          - key: token.priv
            neq: create_object
    - match:  /myapp/objects
      method: GET
      accessPolicy:
      - allOf:
        - key: token.priv
          neq: read_object
```

With above policy config, a `GET /myapp/objects` request wil be denied if the `priv` claim in token does not equal `read_object`. Also, a `POST /myapp/objects` request will be denied if the `priv` claim in token does not equal `create_object`. All other requests will be allowed.
