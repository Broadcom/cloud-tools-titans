{{- $titanSideCars := .titanSideCars }}
{{- if $titanSideCars }}
  {{- $validation := $titanSideCars.validation }}
  {{- if $validation }}
    {{- $environment := $validation.environment }}
    {{- $tests := $validation.tests }}
    {{- if $tests }}

#!/bin/bash
echo ""
echo "### Execute manaul configured local tests ###"


{{ template "test_cases_core_framework" (dict "environment" $environment "tests" $tests) }}

    {{- end }}
  {{- end }}
{{- end }}
