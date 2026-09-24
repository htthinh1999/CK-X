#!/bin/bash

# Setup for Question 7: Create a PersistentVolume named 'pv-storage'

# Create the storage-test namespace if it doesn't exist already
if ! kubectl get namespace storage-test &> /dev/null; then
    kubectl create namespace storage-test
fi

# Delete any existing PV with the same name to ensure a clean state
kubectl delete pv pv-storage --ignore-not-found=true

# Create the /mnt/data directory on the host if possible (this may require privileged access)
# In a real environment, this would need to be handled by the cluster admin
echo "Note: Ensure /mnt/data directory exists on the node for the hostPath volume"

echo "Setup complete for Question 7: Environment ready for creating PersistentVolume 'pv-storage'"
exit 0 