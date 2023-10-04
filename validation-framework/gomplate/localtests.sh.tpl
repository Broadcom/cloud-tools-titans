{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $validation := $titanSideCars.validation }}
  {{- if $validation }}
    {{- $environment := $validation.environment }}
    {{- $tests := $validation.tests }}
    {{- if $tests }}

#!/bin/bash
mkdir -p /tests/logs
exec 2> /tests/logs/localtest-trace.log

echo "" > /tests/logs/report.txt
echo "[`date`]### Execute manaual configured local tests ###" > /tests/logs/report.txt
echo "" >> /tests/logs/report.txt


{{ template "test_cases_core_framework" (dict "environment" $environment "tests" $tests) }}

    {{- end }}
  {{- end }}
{{- end }}
