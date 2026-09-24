#!/bin/bash

# Delete the resources namespace if it exists
echo "Setting up environment for Question 11 (Resource Limits)..."
kubectl delete namespace resources --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 11"
exit 0 