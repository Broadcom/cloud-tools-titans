{{- $titanSideCars := .titanSideCars -}}
{{- $ingress := $titanSideCars.ingress -}}
{{- $validation := $titanSideCars.validation | default dict -}}
{{- $validationEnabled := ternary $validation.enabled true (hasKey $validation "enabled") -}}
{{- if $validationEnabled -}}
  {{- $environment := $validation.environment | default dict -}}
  {{- $containers := $environment.containers | default dict -}}
  {{- $proxy := $containers.proxy | default (dict "image" "envoyproxy/envoy:latest") }}
  {{- $myapp := $containers.myapp | default (dict "image" "ealen/echo-server:latest") }}
  {{- $ratelimit := $containers.ratelimit | default (dict "image" "envoyproxy/ratelimit") }}
  {{- $redis := $containers.redis |default  (dict "image" "redislabs/redistimeseries:latest") }}
  {{- $engine := $containers.engine | default (dict "image" "cfmanteiga/alpine-bash-curl-jq:latest") }}
  {{- $ratelimitEnabled := false -}}
  {{- range $ingress.routes -}}
    {{- if .ratelimit -}}
      {{- $ratelimitEnabled = true -}}
    {{- end -}}
  {{- end -}}
version: '2'
services:
  proxy:
    domainname: mesh.localhost
    image: {{ $proxy.image }}
    volumes:
      - ./envoy:/envoy
      - ./secrets:/secrets
    depends_on:
      - myapp
      - ratelimit
    networks:
      - envoymesh
    expose:
      - "9443"
    ports:
      - "9443:9443"
    entrypoint:
    - /usr/local/bin/envoy
    - -c
    - /envoy/envoy.yaml
    - -l
    - warn
  {{- if $ratelimitEnabled }}
  redis:
    domainname: mesh.localhost
    image: {{ $redis.image }}
    restart: always
    expose:
      - "6379"
    command: redis-server --save 20 1 --loglevel warning
    volumes: 
      - redis:/data
    networks:
      - envoymesh

  ratelimit:
    domainname: mesh.localhost
    image: {{ $ratelimit.image }}
    command: /bin/ratelimit
    expose:
      - "8070"
      - "8081"
      - "6070"
    depends_on:
      - redis
    networks:
      - envoymesh
    volumes:
      - ./envoy:/envoy
    environment:
      - USE_STATSD=false
      - LOG_LEVEL=warn
      - REDIS_SOCKET_TYPE=tcp
      - REDIS_URL=redis:6379
      - REDIS_USE_TLS=false
      - RUNTIME_ROOT=/envoy
      - RUNTIME_SUBDIRECTORY=ratelimit
      - RUNTIME_WATCH_ROOT=false
      - PORT=8070
  {{- end }}
  myapp:
    domainname: mesh.localhost
    image: {{ $myapp.image }}
    expose:
     - "8080"
    networks:
      - envoymesh
    volumes:
      - ./tests:/tests
    environment:
      - PORT=8080
  engine:
    domainname: mesh.localhost
    image: {{ $engine.image }}
    command: /tests/validation-test.sh
    depends_on:
      - redis
      - ratelimit
      - proxy
    networks:
      - envoymesh
    volumes:
      - ./tests:/tests
      - ./secrets:/secrets
volumes:
  redis:
    driver: local
networks:
  envoymesh: {}
{{- end -}}