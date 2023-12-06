#!/bin/sh
dir="$(pwd)"
chart_name=$( grep '^name' Chart.yaml | sed 's/^.*: //' )
chart_version=$( grep '^version' Chart.yaml | sed 's/^.*: //' )
nl='
'
rm -rf "./${chart_name}-${chart_version}.tgz"
workspace=tmp
temp_chart="${workspace}/tmp-chart"
destination="$dir"
[ -d "${workspace}" ] || mkdir $workspace
[ -d "${temp_chart}" ] || mkdir $temp_chart
[ -d "charts" ] || helm dependency update
cp -r templates "$temp_chart"
[ -d "charts" ] && cp -r charts "$temp_chart"
cp Chart.yaml "$temp_chart"
cp values.yaml "$temp_chart"
cp .helmignore "$temp_chart"
cd "$temp_chart" || exit

if  [[ "$OSTYPE" == "darwin"* ]]; then
    find . -type f '(' -name "*.tpl" -o -name "*.yaml" ')' -exec sed -E -i '' "s/(define)([^\"]*\")${chart_name}([^\"]*)\"(.[^\}]*}})(.*)/\\1\2${chart_name}\3\"\4\\${nl}\
{{- include (printf \"%s\3\" (include \"meta.${chart_name}.libId\" . ) ) . }}\\${nl}\
{{- end -}}\\$nl\
{{- \1\2${chart_name}-${chart_version}\3\"\4\5/" {} \;
    find .  -type f '(' -name "*.tpl" -o -name "*.yaml" ')' -exec sed -E -i '' "s/(template|include)([^\"]*\")${chart_name}/\1\2${chart_name}-${chart_version}/g" {} \;
sed -E -i '' "s/^chartName:.*/chartName: ${chart_name}/" values.yaml
sed -E -i '' "s/^chartVersion:.*/chartVersion: ${chart_version}/" values.yaml
else
    find . -type f '(' -name "*.tpl" -o -name "*.yaml" ')' -exec sed -E -i "s/(define)([^\"]*\")${chart_name}([^\"]*)\"(.[^\}]*}})(.*)/\\1\2${chart_name}\3\"\4\\${nl}\
{{- include (printf \"%s\3\" (include \"meta.${chart_name}.libId\" . ) ) . }}\\${nl}\
{{- end -}}\\$nl\
{{- \1\2${chart_name}-${chart_version}\3\"\4\5/g" {} \;
    find . -type f '(' -name "*.tpl" -o -name "*.yaml" ')' -exec sed -E -i "s/(template|include)([^\"]*\")${chart_name}/\1\2${chart_name}-${chart_version}/" {} \;
sed -E -i "s/^chartName:.*/chartName: ${chart_name}/" values.yaml
sed -E -i "s/^chartVersion:.*/chartVersion: ${chart_version}/" values.yaml
fi
 helm package . -d "$destination"
 cd "$dir" || exit
 rm -rf "$temp_chart"