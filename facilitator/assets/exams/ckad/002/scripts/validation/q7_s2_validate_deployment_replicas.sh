#!/bin/bash

# Validate that the broken-deployment exists in troubleshooting namespace
DEPLOYMENT=$(kubectl get deployment broken-deployment -n troubleshooting -o jsonpath='{.spec.replicas}' 2>/dev/null)

if [[ "$DEPLOYMENT" == "3" ]]; then
    # Deployment exists with correct name
    exit 0
else
    # Deployment does not exist or has a different name
    echo "Deployment 'broken-deployment' does not have 3 replicas"
    exit 1
fi 