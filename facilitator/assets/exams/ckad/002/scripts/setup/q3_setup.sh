#!/bin/bash

# Delete the pod-concepts namespace if it exists
echo "Setting up environment for Question 3 (Multi-Container Pod)..."
kubectl delete namespace pod-concepts --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 3"
exit 0 