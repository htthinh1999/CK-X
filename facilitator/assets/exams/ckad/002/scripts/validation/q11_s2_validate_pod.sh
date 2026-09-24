#!/bin/bash

# Validate that the probes-pod exists with correct name and image
POD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "probes-pod" ]]; then
    # Pod exists, now check image
    IMAGE=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx" ]]; then
        # Pod has correct image
        exit 0
    else
        echo "Pod 'probes-pod' does not use the correct image. Found: $IMAGE (expected: nginx)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'probes-pod' does not exist in the 'observability' namespace"
    exit 1
fi 