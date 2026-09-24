#!/bin/bash

# Delete the persistence namespace if it exists
echo "Setting up environment for Question 17 (Persistent Volume Claims)..."
kubectl delete namespace persistence --ignore-not-found=true

# Wait for deletion to complete
sleep 2

# Confirm environment is ready
echo "Environment ready for Question 17"
exit 0 