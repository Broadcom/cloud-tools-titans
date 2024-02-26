domain: {{ .domain }}

descriptors:
{{- range .descriptors }}
- key: {{ .key }}
  value: {{ .value }}
  descriptors:
  {{- range .descriptors }}
    - key: {{ .key }}
      rate_limit:
        unit: hour
        requests_per_unit: 1
  {{- end }}
{{- end }}