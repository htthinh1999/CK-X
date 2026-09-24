#!/bin/bash

# Validate if the Pod 'config-pod' exists and is running in the 'workloads' namespace
POD_STATUS=$(kubectl get pod config-pod -n workloads -o jsonpath='{.status.phase}' 2>/dev/null)

if [ "$POD_STATUS" = "Running" ]; then
    echo "Success: Pod 'config-pod' is running in namespace 'workloads'"
    exit 0
else
    echo "Error: Pod 'config-pod' is not running in namespace 'workloads'. Current status: $POD_STATUS"
    exit 1
fi 