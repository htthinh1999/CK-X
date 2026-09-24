#!/bin/bash

# Validate that the pod exists with correct name and image
POD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "health-check-pod" ]]; then
    # Pod exists, now check image
    IMAGE=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx" ]]; then
        # Pod has correct image
        exit 0
    else
        echo "Pod 'health-check-pod' does not use the correct image. Found: $IMAGE (expected: nginx)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'health-check-pod' does not exist in the 'health-checks' namespace"
    exit 1
fi 