# Service API Metrics Examples

A service can generate fine-grained metrics api level metrics for ingress and well as egress requests into and outof the service. Following sections give an overview of the generated metrics along with some configuration examples.


## Metrics

Metrics are output in `vhost.<service-name>-ingress.vcluster.<metricset-name>.` and `vhost.<service-name>-egress.vcluster.<metricset-name>.` namespaces for requests in `ingress` and `egress` paths respectively. 

Each namespace includes the followings metrics

| Metric | Type | Description |
| --- | --- | --- |
| upstream_rq_<*xx> | Counter | Aggregate HTTP response codes (e.g., 2xx, 3xx, etc.) |
| upstream_rq_<*> | Counter | Specific HTTP response codes (e.g., 201, 302, etc.) |
| upstream_rq_retry | Counter | Total request retries |
| upstream_rq_retry_limit_exceeded | Counter | Total requests not retried due to exceeding the configured number of maximum retries |
| upstream_rq_retry_overflow | Counter | Total requests not retried due to circuit breaking or exceeding the retry budgets |
| upstream_rq_retry_success | Counter | Total request retry successes |
| upstream_rq_time |Histogram | Request time milliseconds |
| upstream_rq_timeout |Counter | Total requests that timed out waiting for a response |
| upstream_rq_total |Counter | Total requests initiated by the router to the upstream |

Related envoy can be found [here](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/route/v3/route_components.proto#envoy-v3-api-msg-config-route-v3-virtualcluster) and [here](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/router_filter#virtual-clusters)



## Examples

### Example 1

Configure metrics for incoming requests into `demoapp` service

```yaml
# service: demoapp
titanSideCars:
  ingress:
    routes:
    - match:
        prefix: /demoapp/projects
        method: POST
      metrics:
        name: create_project  # used as metricset-name
    - match:
        prefix: /demoapp/projects
        method: GET
      metrics:
        name: get_project
    - match:
        prefix: /demoapp/projects
        method: GET
        headers:
        - key: x-client
          eq: democlient
      metrics:
        name: get_project_democlient
```

Above configuration will generate metrics with following prefixes

```yaml
vhost.demoapp-ingress.vcluster.create_project.xxx
vhost.demoapp-ingress.vcluster.get_project.xxx
vhost.demoapp-ingress.vcluster.get_project_democlient.xxx
```

A request is matched against all entries in the routes array. Hence a request will contribute to the metrics set of each route entry that it matches. In above example, a request `GET /demoapp/projects/demoproj` with header `x-client=democlient` will match both second and thrid route entries and hence will contribute to metric sets `get_project` and `get_project_democlient`


### Example 2

Configure metrics for outgoing requests out of `demoapp` service

```yaml
# service: demoapp
titanSideCars:
  egress:
    routes:
    - match:
        prefix: /devices
        method: GET
      metrics:
        name: get_devices
    - match:
        prefix: /devices
        method: POST
      metrics:
        name: create_devices
    - metrics:
        name: users
      route:
        cluster: directory
```

Above configuration will generate metrics with following prefixes
```
vhost.demoapp-egress.vcluster.get_devices.xxx
vhost.demoapp-egress.vcluster.create_devices.xxx
vhost.demoapp-egress.vcluster.users.xxx
```

In above example, the first two routes explicitly specifiy the route match. For third route entry, the route definiton(s) will be picked from the `directory` cluster defintion.

A request is matched against all entries in the routes array and a request will contribute to the metrics bucket of each route entry that it matches. 



