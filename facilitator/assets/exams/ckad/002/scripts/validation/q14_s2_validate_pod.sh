#!/bin/bash

# Validate that the secure-app pod exists
POD=$(kubectl get pod secure-app -n security -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "secure-app" ]]; then
    # Pod exists, now check the image
    IMAGE=$(kubectl get pod secure-app -n security -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
    if [[ "$IMAGE" == "nginx:alpine" ]]; then
        # Image is correct
        exit 0
    else
        echo "Pod 'secure-app' does not use the 'nginx:alpine' image. Found: $IMAGE"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'secure-app' does not exist in the 'security' namespace"
    exit 1
fi 