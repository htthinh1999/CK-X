#!/bin/bash

# Validate that the pod uses ConfigMap as environment variables
POD=$(kubectl get pod app-pod -n configuration -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "app-pod" ]]; then
    # Pod exists, now check if it uses ConfigMap as environment variables
    CONFIG_MAP_ENV=$(kubectl get pod app-pod -n configuration -o jsonpath='{.spec.containers[0].envFrom[?(@.configMapRef.name=="app-config")].configMapRef.name}' 2>/dev/null)
    
    if [[ "$CONFIG_MAP_ENV" == "app-config" ]]; then
        # Pod uses ConfigMap as environment variables
        exit 0
    else
        echo "Pod 'app-pod' does not use ConfigMap 'app-config' as environment variables"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'app-pod' does not exist in the 'configuration' namespace"
    exit 1
fi 