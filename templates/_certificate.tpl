{{- define "titan-mesh-helm-lib-chart.certificate" -}}
{{- $global := $.Values.global -}}
{{- $titanSideCars := mergeOverwrite (deepCopy ($global.titanSideCars | default dict)) ($.Values.titanSideCars | default dict) -}}
{{- if $titanSideCars }}
  {{- $envoyEnabled := eq (include "static.titan-mesh-helm-lib-chart.envoyEnabled" $titanSideCars) "true" -}}
  {{- if $envoyEnabled }}
    {{- $envoy := $titanSideCars.envoy -}}
    {{- $appName := include "titan-mesh-helm-lib-chart.app-name" . -}}
    {{- $appInfo := include "titan-mesh-helm-lib-chart.envoy.canary.service" $appName | fromJson -}}
    {{- $cert := $titanSideCars.cert -}}
    {{- $certDuration := $cert.certDuration | default "8640h" }}
    {{- $certRenewBefore := $cert.certRenewBefore | default "240h" }}
    {{- $certdomain := printf "%s.%s.svc.cluster.local" $appInfo.name $.Release.Namespace }}
    {{- $certname := $certdomain | replace "." "-" }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ $appInfo.name }}
  namespace: {{ .Release.Namespace }}
  annotations:
    "helm.sh/hook": {{ $cert.certHook | default "pre-install, pre-upgrade" }}
    "helm.sh/hook-weight": "-10"

---
apiVersion: v1
kind: Secret
metadata:
  name: {{ print $appInfo.name "-token" }}
  annotations:
    kubernetes.io/service-account.name: {{ $appInfo.name }}
    "helm.sh/hook": {{ $cert.certHook | default "pre-install, pre-upgrade" }}
    "helm.sh/hook-weight": "-10"
type: kubernetes.io/service-account-token

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: {{ $certname }}
  namespace: {{ $.Release.Namespace }}
  annotations:
    "helm.sh/hook": {{ $cert.certHook | default "pre-install, pre-upgrade" }}
    "helm.sh/hook-weight": "5"
spec:
  secretName: {{ print $appInfo.name "-envoy-tls-cert" }}
  duration: {{ $certDuration }}
  renewBefore: {{ $certRenewBefore }}
  commonName: {{ $certdomain }}
  issuerRef:
    name: {{ $cert.issuer | default "vault-issuer" }}
  dnsNames:
  - {{ $certdomain }}
    {{- range $cert.dnsNames }}
  - {{ printf "%s.%s.svc.cluster.local" . $.Release.Namespace }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}