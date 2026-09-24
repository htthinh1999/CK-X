#!/bin/bash

# Validate if the StorageClass 'fast-storage' has the correct provisioner
PROVISIONER=$(kubectl get storageclass fast-storage -o jsonpath='{.provisioner}' 2>/dev/null)

if [ "$PROVISIONER" = "kubernetes.io/no-provisioner" ]; then
    echo "Success: StorageClass 'fast-storage' has the correct provisioner (kubernetes.io/no-provisioner)"
    exit 0
else
    echo "Error: StorageClass 'fast-storage' does not have the correct provisioner. Found: '$PROVISIONER', Expected: 'kubernetes.io/no-provisioner'"
    exit 1
fi 