#!/bin/bash

# Check if the fixed chart.yaml file exists
if [[ ! -f "/tmp/fixed-chart/chart.yaml" ]]; then
  echo "❌ File '/tmp/fixed-chart/chart.yaml' not found"
  exit 1
fi

# Check if the chart.yaml file has correct content
CHART_CONTENT=$(cat /tmp/fixed-chart/chart.yaml)

# Check basic chart properties
if ! grep -q "apiVersion: v2" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'apiVersion: v2'"
  exit 1
fi

if ! grep -q "name: example-app" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'name: example-app'"
  exit 1
fi

if ! grep -q "description: A simple example Helm chart" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have a description"
  exit 1
fi

if ! grep -q "type: application" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'type: application'"
  exit 1
fi

if ! grep -q "version: 0.1.0" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'version: 0.1.0'"
  exit 1
fi

# Check for dependencies section
if ! grep -q "dependencies:" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'dependencies:' section"
  exit 1
fi

# Check for nginx-ingress dependency
if ! grep -q "name: nginx-ingress" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'name: nginx-ingress' under dependencies"
  exit 1
fi

if ! grep -q "version: \"1.41.0\"" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should have 'version: \"1.41.0\"' for nginx-ingress dependency"
  exit 1
fi

if ! grep -q "repository: \"https://charts.bitnami.com/bitnami\"" /tmp/fixed-chart/chart.yaml; then
  echo "❌ chart.yaml should specify Bitnami repository for nginx-ingress"
  exit 1
fi

echo "✅ chart.yaml is properly formatted with correct dependencies"
exit 0 