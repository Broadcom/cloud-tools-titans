#!/bin/sh

schemaDir=""
if [ "$1" ]
then
  schemaDir=$(realpath "$1")
else
  echo "Please specify the schema directory"
  exit 1
fi

if [ -d "$schemaDir" ]
then
  echo "Start to generate markdown documents based on all schema json files under: $schemaDir"
else
  echo "$schemaDir is not a directory"
  exit 1
fi

if ! command -v jsonschema2md &> /dev/null
then
  echo "jsonschema2md tool is required"
  echo "Please following instructions in https://github.com/adobe/jsonschema2md"
  exit 1
fi

rm -rf "$schemaDir"/docs
rm -rf "$schemaDir"/out
jsonschema2md -d "$schemaDir" -e json -x "$schemaDir"/out -o "$schemaDir"/docs
if [[ $? -eq 0 ]]
then
  echo "Docuemnts generated under $schemaDir/docs, please check on $schemaDir/docs/README.md"
  rm -rf "$schemaDir"/out
fi
