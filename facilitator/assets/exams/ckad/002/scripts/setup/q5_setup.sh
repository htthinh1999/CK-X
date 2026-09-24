#!/bin/bash

# Delete the batch namespace if it exists
echo "Setting up environment for Question 5 (CronJob)..."
kubectl delete namespace batch --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 5"
exit 0 