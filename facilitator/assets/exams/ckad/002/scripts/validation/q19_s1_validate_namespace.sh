#!/bin/bash

# Check if namespace exists
NS_EXISTS=$(kubectl get namespace pod-configuration --no-headers --output=name 2>/dev/null | wc -l)
if [[ "$NS_EXISTS" -eq 1 ]]; then
  echo "✅ Namespace 'pod-configuration' exists"
  exit 0
else
  echo "❌ Namespace 'pod-configuration' not found"
  exit 1
fi 