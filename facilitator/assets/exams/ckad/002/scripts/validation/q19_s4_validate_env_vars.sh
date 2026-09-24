#!/bin/bash

# Check if the Pod exists
POD_EXISTS=$(kubectl get pod config-pod -n pod-configuration --no-headers --output=name 2>/dev/null | wc -l)
if [[ "$POD_EXISTS" -eq 0 ]]; then
  echo "❌ Pod 'config-pod' not found in namespace 'pod-configuration'"
  exit 1
fi

# Check for direct environment variables
APP_ENV=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="APP_ENV")].value}' 2>/dev/null)
if [[ "$APP_ENV" != "production" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'APP_ENV=production'"
  exit 1
fi

DEBUG=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="DEBUG")].value}' 2>/dev/null)
if [[ "$DEBUG" != "false" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'DEBUG=false'"
  exit 1
fi

# Check for ConfigMap environment variables
DB_HOST_REF=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_HOST")].valueFrom.configMapKeyRef.name}' 2>/dev/null)
DB_HOST_KEY=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_HOST")].valueFrom.configMapKeyRef.key}' 2>/dev/null)

if [[ "$DB_HOST_REF" != "app-config" || "$DB_HOST_KEY" != "DB_HOST" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'DB_HOST' from ConfigMap 'app-config'"
  exit 1
fi

DB_PORT_REF=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_PORT")].valueFrom.configMapKeyRef.name}' 2>/dev/null)
DB_PORT_KEY=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="DB_PORT")].valueFrom.configMapKeyRef.key}' 2>/dev/null)

if [[ "$DB_PORT_REF" != "app-config" || "$DB_PORT_KEY" != "DB_PORT" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'DB_PORT' from ConfigMap 'app-config'"
  exit 1
fi

# Check for Secret environment variables
API_KEY_REF=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="API_KEY")].valueFrom.secretKeyRef.name}' 2>/dev/null)
API_KEY_KEY=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="API_KEY")].valueFrom.secretKeyRef.key}' 2>/dev/null)

if [[ "$API_KEY_REF" != "app-secret" || "$API_KEY_KEY" != "API_KEY" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'API_KEY' from Secret 'app-secret'"
  exit 1
fi

API_SECRET_REF=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="API_SECRET")].valueFrom.secretKeyRef.name}' 2>/dev/null)
API_SECRET_KEY=$(kubectl get pod config-pod -n pod-configuration -o jsonpath='{.spec.containers[0].env[?(@.name=="API_SECRET")].valueFrom.secretKeyRef.key}' 2>/dev/null)

if [[ "$API_SECRET_REF" != "app-secret" || "$API_SECRET_KEY" != "API_SECRET" ]]; then
  echo "❌ Pod 'config-pod' does not have environment variable 'API_SECRET' from Secret 'app-secret'"
  exit 1
fi

echo "✅ Pod 'config-pod' has all required environment variables configured correctly"
exit 0 