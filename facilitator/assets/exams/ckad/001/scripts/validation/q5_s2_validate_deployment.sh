#!/bin/bash

# Validate if the deployment 'nginx-deployment' exists in the 'dev' namespace
if kubectl get deployment nginx-deployment -n dev &> /dev/null; then
    echo "Success: Deployment 'nginx-deployment' exists in namespace 'dev'"
    exit 0
else
    echo "Error: Deployment 'nginx-deployment' does not exist in namespace 'dev'"
    exit 1
fi 