#!/bin/bash

# Validate that resource limits and requests are configured correctly
POD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "probes-pod" ]]; then
    # Pod exists, now check resource requests and limits
    # Check CPU request
    CPU_REQUEST=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
    
    # Check memory request
    MEM_REQUEST=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
    
    # Check CPU limit
    CPU_LIMIT=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
    
    # Check memory limit
    MEM_LIMIT=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
    
    if [[ "$CPU_REQUEST" == "100m" && "$MEM_REQUEST" == "128Mi" && "$CPU_LIMIT" == "200m" && "$MEM_LIMIT" == "256Mi" ]]; then
        # Resources are configured correctly
        exit 0
    else
        echo "Resource limits and requests are not configured correctly."
        echo "Found CPU request: $CPU_REQUEST (expected: 100m)"
        echo "Found memory request: $MEM_REQUEST (expected: 128Mi)"
        echo "Found CPU limit: $CPU_LIMIT (expected: 200m)"
        echo "Found memory limit: $MEM_LIMIT (expected: 256Mi)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'probes-pod' does not exist in the 'observability' namespace"
    exit 1
fi 