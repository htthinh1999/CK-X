#!/bin/bash

# Validate that the multi-container-pod exists
POD=$(kubectl get pod multi-container-pod -n multi-container -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "multi-container-pod" ]]; then
    # Pod exists, now check if it has two containers (app containers + native sidecars, i.e. init containers with restartPolicy Always)
    CONTAINER_COUNT=$(kubectl get pod multi-container-pod -n multi-container -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length')
    
    if [[ "$CONTAINER_COUNT" == "2" ]]; then
        # Pod has two containers
        exit 0
    else
        echo "Pod 'multi-container-pod' does not have two containers. Found: $CONTAINER_COUNT"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'multi-container-pod' does not exist in the 'multi-container' namespace"
    exit 1
fi 