#!/bin/bash

# Validate that the pod exists with correct name and image
POD=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "lifecycle-pod" ]]; then
    # Pod exists, now check image
    IMAGE=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx" ]]; then
        # Pod has correct image
        exit 0
    else
        echo "Pod 'lifecycle-pod' does not use the correct image. Found: $IMAGE (expected: nginx)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'lifecycle-pod' does not exist in the 'pod-lifecycle' namespace"
    exit 1
fi 