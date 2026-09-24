#!/bin/bash

# Delete the health-checks namespace if it exists
echo "Setting up environment for Question 4 (Health Checks)..."
kubectl delete namespace health-checks --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 4"
exit 0 