#!/bin/bash

# Validate if the ConfigMap 'app-config' exists in the 'workloads' namespace with correct data
APP_ENV=$(kubectl get configmap app-config -n workloads -o jsonpath='{.data.APP_ENV}' 2>/dev/null)
LOG_LEVEL=$(kubectl get configmap app-config -n workloads -o jsonpath='{.data.LOG_LEVEL}' 2>/dev/null)

if [ "$APP_ENV" = "production" ] && [ "$LOG_LEVEL" = "info" ]; then
    echo "Success: ConfigMap 'app-config' exists with correct key-value pairs"
    exit 0
else
    echo "Error: ConfigMap 'app-config' does not have the correct data."
    echo "Expected: APP_ENV=production, LOG_LEVEL=info"
    echo "Found: APP_ENV=$APP_ENV, LOG_LEVEL=$LOG_LEVEL"
    exit 1
fi 