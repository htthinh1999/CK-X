#!/bin/bash

# Check if the Secret exists
SECRET_EXISTS=$(kubectl get secret app-secret -n pod-configuration --no-headers --output=name 2>/dev/null | wc -l)
if [[ "$SECRET_EXISTS" -eq 0 ]]; then
  echo "❌ Secret 'app-secret' not found in namespace 'pod-configuration'"
  exit 1
fi

# Check for required keys
API_KEY=$(kubectl get secret app-secret -n pod-configuration -o jsonpath='{.data.API_KEY}' 2>/dev/null)
if [[ -z "$API_KEY" ]]; then
  echo "❌ Secret 'app-secret' is missing key 'API_KEY'"
  exit 1
fi

API_SECRET=$(kubectl get secret app-secret -n pod-configuration -o jsonpath='{.data.API_SECRET}' 2>/dev/null)
if [[ -z "$API_SECRET" ]]; then
  echo "❌ Secret 'app-secret' is missing key 'API_SECRET'"
  exit 1
fi

echo "✅ Secret 'app-secret' exists with required keys in namespace 'pod-configuration'"
exit 0 