#!/bin/bash

# Delete the pod-lifecycle namespace if it exists
echo "Setting up environment for Question 8 (Pod Lifecycle)..."
kubectl delete namespace pod-lifecycle --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 8"
exit 0 