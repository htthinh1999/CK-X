#!/bin/bash

# Setup for Question 9: Create a StorageClass named 'fast-storage'

# Delete any existing StorageClass with the same name to ensure a clean state
kubectl delete storageclass slow-storage --ignore-not-found=true

echo "Setup complete for Question 9: Environment ready for creating StorageClass 'fast-storage'"
exit 0 