#!/bin/bash

# Validate if the Pod 'config-pod' in namespace 'workloads' has the correct resource requirements
POD_EXISTS=$(kubectl get pod config-pod -n workloads -o name 2>/dev/null)

if [ -z "$POD_EXISTS" ]; then
    echo "Error: Pod 'config-pod' does not exist in namespace 'workloads'"
    exit 1
fi

# Extract resource limits and requests
CPU_REQUEST=$(kubectl get pod config-pod -n workloads -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
CPU_LIMIT=$(kubectl get pod config-pod -n workloads -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
MEM_REQUEST=$(kubectl get pod config-pod -n workloads -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
MEM_LIMIT=$(kubectl get pod config-pod -n workloads -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)

# Check if resources are defined
if [ -z "$CPU_REQUEST" ] || [ -z "$CPU_LIMIT" ] || [ -z "$MEM_REQUEST" ] || [ -z "$MEM_LIMIT" ]; then
    echo "Error: Resource requirements not fully defined for Pod 'config-pod'"
    echo "Found: CPU request='$CPU_REQUEST', CPU limit='$CPU_LIMIT', Memory request='$MEM_REQUEST', Memory limit='$MEM_LIMIT'"
    exit 1
fi

# Check if resources match expected values
if [ "$CPU_REQUEST" = "100m" ] && [ "$CPU_LIMIT" = "200m" ] && [ "$MEM_REQUEST" = "128Mi" ] && [ "$MEM_LIMIT" = "256Mi" ]; then
    echo "Success: Pod 'config-pod' has the correct resource requirements"
    exit 0
else
    echo "Error: Pod 'config-pod' does not have the correct resource requirements"
    echo "Expected: CPU request='100m', CPU limit='200m', Memory request='128Mi', Memory limit='256Mi'"
    echo "Found: CPU request='$CPU_REQUEST', CPU limit='$CPU_LIMIT', Memory request='$MEM_REQUEST', Memory limit='$MEM_LIMIT'"
    exit 1
fi 