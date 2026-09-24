#!/bin/bash

# Setup for Question 17: Multi-container pod with shared volume

# Create the troubleshooting namespace if it doesn't exist already
if ! kubectl get namespace troubleshooting &> /dev/null; then
    kubectl create namespace troubleshooting
fi

# Delete any existing pod with the same name
kubectl delete pod sidecar-pod -n troubleshooting --ignore-not-found=true

echo "Setup complete for Question 17: Environment ready for creating a multi-container pod with shared volume"
exit 0 