#!/bin/bash

# Validate if the StorageClass 'fast-storage' exists
if kubectl get storageclass fast-storage &> /dev/null; then
    echo "Success: StorageClass 'fast-storage' exists"
    exit 0
else
    echo "Error: StorageClass 'fast-storage' does not exist"
    exit 1
fi 