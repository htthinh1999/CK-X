#!/bin/bash

# Validate that the db-pod exists with correct image
POD=$(kubectl get pod db-pod -n state -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "db-pod" ]]; then
    # Pod exists, now check image
    IMAGE=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$IMAGE" == "mysql:5.7" ]]; then
        # Pod has correct image
        exit 0
    else
        echo "Pod 'db-pod' does not use the correct image. Found: $IMAGE (expected: mysql:5.7)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'db-pod' does not exist in the 'state' namespace"
    exit 1
fi 