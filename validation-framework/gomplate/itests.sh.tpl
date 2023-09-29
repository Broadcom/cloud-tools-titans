{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $integration := $titanSideCars.integration }}
  {{- if $integration }}
    {{- $environment := $integration.environment }}
    {{- $logFolder := $environment.logFolder | default "./logs" }}
    {{- $tests := $integration.tests }}
    {{- if $tests }}

#!/bin/bash
echo "" >> {{ $logFolder }}/report.txt
echo "[`date`]### Execute manaual configured integration tests ###" > {{ $logFolder }}/report.txt
echo "" >> {{ $logFolder }}/report.txt


{{ template "test_cases_core_framework" (dict "environment" $environment "tests" $tests) }}

    {{- end }}
  {{- end }}
{{- end }}
