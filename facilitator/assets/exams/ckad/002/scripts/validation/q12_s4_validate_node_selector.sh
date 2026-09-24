#!/bin/bash

# Validate that the pod has the correct node selector
POD=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "scheduled-pod" ]]; then
    # Pod exists, check if it has a node selector
    NODE_SELECTOR=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.spec.nodeSelector.disk}' 2>/dev/null)
    
    if [[ "$NODE_SELECTOR" == "ssd" ]]; then
        # Pod has correct node selector
        exit 0
    else
        echo "Pod 'scheduled-pod' does not have the correct node selector. Expected nodeSelector.disk=ssd, found: $NODE_SELECTOR"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'scheduled-pod' does not exist in the 'pod-scheduling' namespace"
    exit 1
fi 