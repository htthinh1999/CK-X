#!/bin/bash

# Validate that the broken-deployment exists in troubleshooting namespace
DEPLOYMENT=$(kubectl get deployment broken-deployment -n troubleshooting -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$DEPLOYMENT" == "broken-deployment" ]]; then
    # Deployment exists with correct name
    exit 0
else
    # Deployment does not exist or has a different name
    echo "Deployment 'broken-deployment' does not exist in namespace 'troubleshooting'"
    exit 1
fi 