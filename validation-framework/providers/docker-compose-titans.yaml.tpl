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
  {{- $tokenGenerator := index $containers "token-generator" }}
  {{- $ratelimitEnabled := false -}}
  {{- range $ingress.routes -}}
    {{- if .ratelimit -}}
      {{- $ratelimitEnabled = true -}}
    {{- end -}}
  {{- end -}}
version: '2'
services:
  proxy:
    image: {{ $proxy.image }}
    volumes:
      - ./envoy/config:/envoy/config
      - ./envoy/ratelimit:/envoy/ratelimit
      - ./secrets:/secrets
      - ./tests:/tests
    depends_on:
      - myapp
      - ratelimit
    networks:
      - envoymesh
    expose:
      - "9443"
      - "9565"
    entrypoint:
    - /usr/local/bin/envoy
    - -c
    - /envoy/config/envoy.yaml
    - -l
    - warn
    - '--log-path'
    - /tests/logs/envoy.application.log
  {{- if $ratelimitEnabled }}
  redis:
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
    image: {{ $myapp.image }}
    expose:
     - "8080"
    networks:
      - envoymesh
    volumes:
      - ./tests:/tests
    environment:
      - PORT=8080
  {{- if $tokenGenerator }}
  token-generator:
    image: {{ $tokenGenerator.image }}
    entrypoint: 
      - /usr/local/broadcom/tokentools/token-generator 
      - -logfile
      - stdout
      - -issuer
      - http://token-generator
    expose:
     - "8080"
    networks:
      - envoymesh
    environment:
      - PORT=8080
  {{- end }}
  engine:
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