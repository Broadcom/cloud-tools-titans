{{- $titanSideCars := .titanSideCars }}
  {{- $tracing := $titanSideCars.tracing }}
  {{- $tracingEnabled := ternary $tracing.enabled false (hasKey $tracing "enabled") }}
  {{- if $tracingEnabled }}
    {{- $collector := $tracing.collector -}}
    {{- $receivers := $collector.receivers -}}
    {{- $otlp := $receivers.otlp -}}
    {{- $exporters := $collector.exporters -}}
    {{- $jaeger := $exporters.jaeger -}}
    {{- $deployAsSidecar := $collector.deployAsSidecar | default false -}}
    {{- if $deployAsSidecar }}
      {{- $resource := $collector.resource | default dict -}}
      {{- $cpu := $resource.cpu | default dict -}}
      {{- $memory := $resource.memory | default dict -}}
      {{- $storage := $resource.memory | default dict -}}
      {{- $console := $collector.console | default dict -}}
      {{- if hasKey $memory "request" }}
        {{- printf "$memory=%v\n" $memory }}
      {{- else }}
        {{- printf "$memory=%s\n" "512" }}
        size_mib: {{ ternary (trimSuffix "Mi" (printf "%s" $memory.request)) "512" (hasKey $memory "request") }}
      {{- end }}


otel-collector-config.yaml: |
  extensions:
    memory_ballast:
      size_mib: {{ ternary (trimSuffix "Mi" (printf "%s" $memory.request)) "512" (hasKey $memory "request") }}
    zpages:
      endpoint: {{ printf "0.0.0.0:%s" ($console.port | default "55679") }}
    health_check:

  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:{{ $otlp.port | default "4317" }}
        http:

  processors:
    batch:
    memory_limiter:
      # 75% of maximum memory up to 4G
      limit_mib: {{ ternary (trimSuffix "Mi" (printf "%s" $memory.limit)) "1536" (hasKey $memory "limit") }}
      # 25% of limit up to 2G
      spike_limit_mib: {{ ternary (trimSuffix "Mi" (printf "%s" $memory.request)) "512" (hasKey $memory "request") }}
      check_interval: {{ $collector.healthCheckInterval |  default "5s" }}

  exporters:
    logging:
      loglevel: {{ $collector.logLevel |  default "debug" }}
    otlp/jaeger:
      endpoint: {{ printf "%s:%s" ($jaeger.address | default "jaeger") ($jaeger.port | default "4317") }}

  service:
    pipelines:
      traces:
        receivers: [otlp]
        processors: [memory_limiter, batch]
        exporters: [logging]
      metrics:
        receivers: [otlp]
        processors: [memory_limiter, batch]
        exporters: [logging]

    extensions: [memory_ballast, zpages, health_check]

    {{- end }}

  {{- end }}