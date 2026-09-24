#!/bin/bash

# Validate that the deployment has the correct number of replicas
REPLICAS=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.spec.replicas}' 2>/dev/null)

if [[ "$REPLICAS" == "3" ]]; then
    # Deployment has correct number of replicas
    exit 0
else
    # Deployment has incorrect number of replicas
    echo "Deployment 'frontend' does not have correct number of replicas. Found: $REPLICAS (expected: 3)"
    exit 1
fi 