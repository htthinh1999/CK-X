#!/bin/bash

# Delete the config-management namespace if it exists
echo "Setting up environment for Question 9 (ConfigMap)..."
kubectl delete namespace config-management --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 9"
exit 0 