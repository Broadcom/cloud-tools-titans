# Global Ratelimiting Examples

Following examples guide through various ratelimit scenarios.

### Example 1

Lets start with a simple example that ratelimits a matching route
```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - limit: 100/minute   # supported units - second, minute, hour, day
```

Above configuration will limit all 'POST' requests starting with '/myapp/objects' to 100 per minute.


### Example 2

Lets take a slightly more complex case where we ratelimit on each unique value of a `header`

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - descriptors:
          - key: x-product  # may also say header.x-myapp-header. 'header.' is default
          limit: 100/minute
```

In above configuration we again target `POST` requests starting with `/myapp/objects`. But now limit will be applied independently to each unique value of the header `x-product`. <br />
Header `x-product` with values `prod1` and `prod2` each will be independently allowed 100 times per minute


### Example 3

We can also ratelimit on an attribute from `payload`. Lets look at an example

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects 
        method: POST
      ratelimit:
        actions:
        - descriptors:
          - key: payload.email  # 'payload.' notation references payload attributes
          limit: 100/minute
```

Above config will trigger ratelimit on each unique email in the payload of `POST` requests starting with `/myapp/objects`. No ratelimiting will be triggered if payload does not contain the specified attribute. <br />
A sample payload like `{"name": "foo", "email": "foo@example.com"}` will trigger above ratelimit action


### Example 4

We can even ratelimit on a claim inside `token` as in following example

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects 
        method: POST
      ratelimit:
        actions:
        - descriptors:
          - key: token.jti      # 'token.' notation references token claims
          limit: 100/minute
```

With above config in place, a token with a specfic `jti` claim will be ratelimited to 100 requests per minute for `POST` requests starting with `/myapp/objects`


### Example 5
Lets dig deeper and look at a more complex ratelimit action with multiple descriptors.

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - descriptors:
          - key: x-product
            eq: myprod
          - key: payload.email
          limit: 100/minute
```
In above config, the ratelimit has a single action with multiple descriptors. For an action to trigger, all its descriptors must match the incoming request.  <br />
A `POST` request starting with `/myapp/objects` and header `x-product` with value `myprod` will be ratelimited to 100 per minute for each unique value of `email` attribute in payload.

The order of descriptors is immaterial. Following config will have identical effect

```yaml
    actions:
    - descriptors:
      - key: payload.email
      - key: x-product
        eq: myprod
      limit: 100/minute
```

Above may also be re-written as following with identical effect

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects/
        method: GET
        headers:
        - name: x-product
          exact: myprod
      ratelimit:
        actions:
        - descriptors:
          - key: payload.email
          limit: 100/minute
```

Instead of matching 'x-product' header in the descriptor it may be matched in the route defintion itself. Route defintion is implicitly part of every ratelimit action. Hence the above config has same effect as the original. 

Comparision operation inside ratelimit action is more useful when dealing with attributes from token or payload as we will see in later examples. The routes[].match only allows header comparison.


### Example 6
We now pick up a ratelimit config with multiple ratelimit actions

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - descriptors:
          - key: payload.email
          limit: 100/minute
        - descriptors:
          - key: payload.email
            eq: foo@example.com
          limit: 5/minute
```

Above targets `POST` requests starting with `/myapp/objects` and has two ratelimit actions. First action sets a limit of 100 per minute on each unique `email` in payload. The second action sets a limit of 5 per minute if `email` in payload equals `foo@example.com`. <br />
Hence emails `bar@example.com` and `car@example.com` will be allowed 100 times per minute each, but `foo@example.com` will be restricted to 5 times per minute. 

When multiple actions are configured, each action is evaluated indendendently. The most constraining action gets enforced. The order of actions is immaterial. Following config wll have identical effect.

```yaml
  actions:
  - descriptors:
    - key: payload.email
      eq: foo@example.com
    limit: 5/minute
  - descriptors:
    - key: payload.email
    limit: 100/minute
```


### Example 7

Lets look at an example where a request matches multiple route definitions

```yaml
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
      ratelimit:
        actions:
        - limit: 100/minute      
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - limit: 10/minute
```

A `POST` request starting with `/myapp/objects` will match both the first and second route. Ratelimit actions on each route will be evaluated independently and the most constraining limit will be enforced (10 per minute in this case)


### Example 8

Following example shows how to configure different limits for different environment without duplicating the ratelimit rules in each deployment

```yaml
titanSideCars:
  # can be overwritten per environment
  ratelimit:
    limits: # holds custom key value pairs
      small: 10/hour
      large: 100/minute

  # configured in service's values.yaml
  ingress:
    routes:
    - match:
        prefix: /myapp/objects
        method: POST
      ratelimit:
        actions:
        - limit: small  # refers to a key inside titanSideCars.ratelimit.limits
    - match:
        prefix: /myapp/objects
        method: GET
      ratelimit:
        actions:
        - limit: large
```



