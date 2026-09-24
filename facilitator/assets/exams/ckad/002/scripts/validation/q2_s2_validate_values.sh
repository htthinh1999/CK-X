#!/bin/bash

# Check if the fixed values.yaml file exists
if [[ ! -f "/tmp/fixed-chart/values.yaml" ]]; then
  echo "❌ File '/tmp/fixed-chart/values.yaml' not found"
  exit 1
fi

# Check if the values.yaml file has correct content
VALUES_CONTENT=$(cat /tmp/fixed-chart/values.yaml)

# Check replicaCount
if ! grep -q "replicaCount: 2" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'replicaCount: 2'"
  exit 1
fi

# Check image section
if ! grep -q "image:" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'image:' section"
  exit 1
fi

if ! grep -q "repository: nginx" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'repository: nginx' under image section"
  exit 1
fi

if ! grep -q "tag: 1.19.0" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'tag: 1.19.0' under image section"
  exit 1
fi

# Check service section
if ! grep -q "service:" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'service:' section"
  exit 1
fi

if ! grep -q "type: ClusterIP" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'type: ClusterIP' under service section"
  exit 1
fi

# Check resources section
if ! grep -q "resources:" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'resources:' section"
  exit 1
fi

if ! grep -q "limits:" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'limits:' under resources section"
  exit 1
fi

if ! grep -q "cpu: 100m" /tmp/fixed-chart/values.yaml; then
  echo "❌ values.yaml should have 'cpu: 100m' under limits section"
  exit 1
fi

# Check for correct indentation
# This is a simple check - in a real exam we would need more comprehensive validation
INDENT_CHECK=$(grep -E '^ {2}[a-z]+:' /tmp/fixed-chart/values.yaml | wc -l)
if [[ "$INDENT_CHECK" -lt 3 ]]; then
  echo "❌ values.yaml does not have proper indentation"
  exit 1
fi

echo "✅ values.yaml is properly formatted with correct content"
exit 0 