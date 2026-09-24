#!/bin/bash

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
  echo "Helm is not available, skipping setup"
  exit 0
fi

# Clean up any existing resources
kubectl delete namespace helm-basics --ignore-not-found=true


echo "Setup complete for Question 2"
exit 0 