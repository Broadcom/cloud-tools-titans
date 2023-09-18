#!/bin/bash
helm template validation . --output-dir "$PWD/tmp" -n validation -f values.yaml -f values-test.yaml
