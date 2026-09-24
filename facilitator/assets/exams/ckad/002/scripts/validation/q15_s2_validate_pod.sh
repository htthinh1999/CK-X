#!/bin/bash

# Validate that the network-pod exists
POD=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "network-pod" ]]; then
    # Pod exists, check image
    IMAGE=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx:alpine" ]]; then
        # Pod has correct image
        exit 0
    else
        echo "Pod 'network-pod' has incorrect image. Found: $IMAGE (expected: nginx:alpine)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'network-pod' does not exist in the 'pod-networking' namespace"
    exit 1
fi 