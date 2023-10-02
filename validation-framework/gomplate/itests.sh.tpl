{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $integration := $titanSideCars.integration }}
  {{- if $integration }}
    {{- $environment := $integration.environment }}
    {{- $logFolder := $environment.logFolder | default "./logs" }}
    {{- $tests := $integration.tests }}
    {{- if $tests }}

#!/bin/bash
mkdir -p {{ $logFolder }}
echo "" >> {{ $logFolder }}/report.txt
echo "[`date`]### Execute manaual configured integration tests ###" > {{ $logFolder }}/report.txt
echo "" >> {{ $logFolder }}/report.txt
exec 2> {{ $logFolder }}/itest-trace.log


{{ template "test_cases_core_framework" (dict "environment" $environment "tests" $tests "remote" true) }}

    {{- end }}
  {{- end }}
{{- end }}
