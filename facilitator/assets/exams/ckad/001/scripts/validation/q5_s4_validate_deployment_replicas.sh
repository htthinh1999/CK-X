#!/bin/bash

# Validate if the deployment 'nginx-deployment' in namespace 'dev' has 3 replicas
REPLICAS=$(kubectl get deployment nginx-deployment -n dev -o jsonpath='{.spec.replicas}' 2>/dev/null)

if [ "$REPLICAS" = "3" ]; then
    echo "Success: Deployment 'nginx-deployment' has the correct number of replicas (3)"
    exit 0
else
    echo "Error: Deployment 'nginx-deployment' does not have the correct number of replicas. Found: '$REPLICAS', Expected: '3'"
    exit 1
fi 