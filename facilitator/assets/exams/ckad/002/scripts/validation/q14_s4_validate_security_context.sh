#!/bin/bash

# Validate that security context is configured correctly
# Check readOnlyRootFilesystem
READONLY_ROOT=$(kubectl get pod secure-app -n security -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)

# Check if capabilities are dropped
DROP_ALL=$(kubectl get pod secure-app -n security -o jsonpath='{.spec.containers[0].securityContext.capabilities.drop}' 2>/dev/null)

if [[ "$READONLY_ROOT" == "true" ]]; then
    # readOnlyRootFilesystem is configured correctly
    if [[ "$DROP_ALL" == *"ALL"* ]]; then
        # Capabilities are dropped correctly
        exit 0
    else
        echo "Pod 'secure-app' does not drop all capabilities. Found: $DROP_ALL"
        exit 1
    fi
else
    echo "Pod 'secure-app' does not have readOnlyRootFilesystem set to true. Found: $READONLY_ROOT"
    exit 1
fi 