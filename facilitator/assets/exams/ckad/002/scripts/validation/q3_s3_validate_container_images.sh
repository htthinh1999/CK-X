#!/bin/bash

# Validate that the container images are correct
MAIN_CONTAINER_IMAGE=$(kubectl get pod multi-container-pod -n multi-container -o jsonpath='{.spec.containers[?(@.name=="main-container")].image}' 2>/dev/null)
SIDECAR_CONTAINER_IMAGE=$(kubectl get pod multi-container-pod -n multi-container -o jsonpath='{.spec.containers[?(@.name=="sidecar-container")].image}' 2>/dev/null)

if [[ "$MAIN_CONTAINER_IMAGE" == "nginx" ]]; then
    # Main container image is correct
    if [[ "$SIDECAR_CONTAINER_IMAGE" == "busybox" ]]; then
        # Sidecar container image is correct
        exit 0
    else
        echo "Sidecar container image is incorrect. Found: $SIDECAR_CONTAINER_IMAGE (expected: busybox)"
        exit 1
    fi
else
    echo "Main container image is incorrect. Found: $MAIN_CONTAINER_IMAGE (expected: nginx)"
    exit 1
fi 