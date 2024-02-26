{{- $titanSideCars := .titanSideCars -}}
{{- $globalRateLimit := $titanSideCars.ratelimit }}
{{- $globalRateLimitEnabled := true }}
{{- if hasKey $globalRateLimit "enabled" }}
  {{- $globalRateLimitEnabled = $globalRateLimit.enabled }}
{{- end }}
{{- $ingress := $titanSideCars.ingress -}}
{{- $validation := $titanSideCars.validation | default dict -}}
{{- $validationEnabled := ternary $validation.enabled true (hasKey $validation "enabled") -}}
{{- if $validationEnabled -}}
  {{- $environment := $validation.environment | default dict -}}
  {{- $containers := $environment.containers | default dict -}}
  {{- $proxy := $containers.proxy | default (dict "image" "envoyproxy/envoy:latest") }}
  {{- $myapp := $containers.myapp | default (dict "image" "ealen/echo-server:latest") }}
  {{- $ratelimit := $containers.ratelimit | default (dict "image" "envoyproxy/ratelimit:latest") }}
  {{- $redis := $containers.redis |default  (dict "image" "redislabs/redistimeseries:latest") }}
  {{- $engine := $containers.engine | default (dict "image" "cfmanteiga/alpine-bash-curl-jq:latest") }}
  {{- $tokenGenerator := index $containers "token-generator" }}
  {{- $ratelimitEnabled := false -}}
  {{- if $globalRateLimitEnabled }}
    {{- range $ingress.routes -}}
      {{- if .ratelimit -}}
        {{- $ratelimitEnabled = true -}}
      {{- end -}}
    {{- end -}}
  {{- end }}
version: '3.7'
services:
  proxy:
    user: root
    image: {{ $proxy.image }}
    platform: linux/amd64
    volumes:
      - ./envoy/config:/envoy/config
      - ./envoy/ratelimit:/envoy/ratelimit
      - ./secrets:/secrets
      - ./tests:/tests
    depends_on:
      - myapp
  {{- if $ratelimitEnabled }}
      - ratelimit
  {{- end }}
  {{- if $tokenGenerator }}
      - token-generator
  {{- end }}
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
    platform: linux/amd64
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
    platform: linux/amd64
    command: /bin/ratelimit
    user: root
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
      - SHADOW_MODE=false
      - PORT=8070
  {{- end }}
  myapp:
    image: {{ $myapp.image }}
    platform: linux/amd64
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
    platform: linux/amd64
    entrypoint:
    {{- $tokenGenerator.cmds | default (list "/usr/local/broadcom/token-generator/token-generator" "-logFile" "stdout" "-issuer" "http://token-generator" "-useDynamicKey" "true") | toYaml | nindent 6 }}
    expose:
     - "8080"
    networks:
      - envoymesh
    environment:
      - PORT=8080
  {{- end }}
  engine:
    image: {{ $engine.image }}
    platform: linux/amd64
    entrypoint: 
      - tail 
      - -f
      - /dev/null
#    command: /tests/validation-test.sh
    depends_on:
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