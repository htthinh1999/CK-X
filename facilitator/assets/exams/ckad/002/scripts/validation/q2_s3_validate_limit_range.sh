#!/bin/bash

# Validate that the compute-limits LimitRange exists with correct defaults
LIMIT_RANGE=$(kubectl get limitrange compute-limits -n resource-management -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$LIMIT_RANGE" == "compute-limits" ]]; then
    # LimitRange exists, now check if it has correct default values
    
    # Check default CPU request
    DEFAULT_CPU_REQUEST=$(kubectl get limitrange compute-limits -n resource-management -o jsonpath='{.spec.limits[?(@.type=="Container")].defaultRequest.cpu}' 2>/dev/null)
    
    # Check default CPU limit
    DEFAULT_CPU_LIMIT=$(kubectl get limitrange compute-limits -n resource-management -o jsonpath='{.spec.limits[?(@.type=="Container")].default.cpu}' 2>/dev/null)
    
    # Check default memory request
    DEFAULT_MEM_REQUEST=$(kubectl get limitrange compute-limits -n resource-management -o jsonpath='{.spec.limits[?(@.type=="Container")].defaultRequest.memory}' 2>/dev/null)
    
    # Check default memory limit
    DEFAULT_MEM_LIMIT=$(kubectl get limitrange compute-limits -n resource-management -o jsonpath='{.spec.limits[?(@.type=="Container")].default.memory}' 2>/dev/null)
    
    if [[ "$DEFAULT_CPU_REQUEST" == "100m" && 
          "$DEFAULT_CPU_LIMIT" == "200m" && 
          "$DEFAULT_MEM_REQUEST" == "128Mi" && 
          "$DEFAULT_MEM_LIMIT" == "256Mi" ]]; then
        # LimitRange has correct default values
        exit 0
    else
        echo "LimitRange 'compute-limits' does not have correct default values."
        echo "Found default CPU request: $DEFAULT_CPU_REQUEST (expected: 100m)"
        echo "Found default CPU limit: $DEFAULT_CPU_LIMIT (expected: 200m)"
        echo "Found default memory request: $DEFAULT_MEM_REQUEST (expected: 128Mi)"
        echo "Found default memory limit: $DEFAULT_MEM_LIMIT (expected: 256Mi)"
        exit 1
    fi
else
    # LimitRange does not exist
    echo "LimitRange 'compute-limits' does not exist in the 'resource-management' namespace"
    exit 1
fi 