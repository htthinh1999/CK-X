#!/bin/bash

# Check if the ConfigMap exists
CM_EXISTS=$(kubectl get configmap app-config -n pod-configuration --no-headers --output=name 2>/dev/null | wc -l)
if [[ "$CM_EXISTS" -eq 0 ]]; then
  echo "❌ ConfigMap 'app-config' not found in namespace 'pod-configuration'"
  exit 1
fi

# Check for required keys
DB_HOST=$(kubectl get configmap app-config -n pod-configuration -o jsonpath='{.data.DB_HOST}' 2>/dev/null)
if [[ -z "$DB_HOST" ]]; then
  echo "❌ ConfigMap 'app-config' is missing key 'DB_HOST'"
  exit 1
fi

DB_PORT=$(kubectl get configmap app-config -n pod-configuration -o jsonpath='{.data.DB_PORT}' 2>/dev/null)
if [[ -z "$DB_PORT" ]]; then
  echo "❌ ConfigMap 'app-config' is missing key 'DB_PORT'"
  exit 1
fi

echo "✅ ConfigMap 'app-config' exists with required keys in namespace 'pod-configuration'"
exit 0 