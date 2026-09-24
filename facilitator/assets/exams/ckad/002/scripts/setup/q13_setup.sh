#!/bin/bash

# Delete the services namespace if it exists
echo "Setting up environment for Question 13 (Services)..."
kubectl delete namespace services --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 13"
exit 0 