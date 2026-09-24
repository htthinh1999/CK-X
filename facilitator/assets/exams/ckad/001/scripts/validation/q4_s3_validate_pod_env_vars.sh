#!/bin/bash

# Validate if the Pod 'config-pod' has the environment variables from the ConfigMap
POD_APP_ENV=$(kubectl exec config-pod -n workloads -- env | grep APP_ENV | cut -d '=' -f 2 2>/dev/null)
POD_LOG_LEVEL=$(kubectl exec config-pod -n workloads -- env | grep LOG_LEVEL | cut -d '=' -f 2 2>/dev/null)

if [ "$POD_APP_ENV" = "production" ] && [ "$POD_LOG_LEVEL" = "info" ]; then
    echo "Success: Pod 'config-pod' has the correct environment variables from ConfigMap"
    exit 0
else
    echo "Error: Pod 'config-pod' does not have the correct environment variables."
    echo "Expected: APP_ENV=production, LOG_LEVEL=info"
    echo "Found: APP_ENV=$POD_APP_ENV, LOG_LEVEL=$POD_LOG_LEVEL"
    exit 1
fi 