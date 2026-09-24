#!/bin/bash

# Setup for Question 5: Create a deployment called nginx-deployment in namespace dev

# Create the namespace if it doesn't exist already
if kubectl get namespace dev &> /dev/null; then
    kubectl delete namespace dev --ignore-not-found=true
fi

# Delete any existing deployment with the same name to ensure a clean state
kubectl delete deployment nginx-deployment -n dev --ignore-not-found=true

echo "Setup complete for Question 5: Environment ready for creating nginx deployment in namespace 'dev'"
exit 0 