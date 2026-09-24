#!/bin/bash

# Validate if PersistentVolumeClaim uses correct StorageClass
STORAGE_CLASS=$(kubectl get pvc pvc-app -n storage-test -o jsonpath='{.spec.storageClassName}' 2>/dev/null)

if [ "$STORAGE_CLASS" = "fast-storage" ]; then
    echo "Success: PersistentVolumeClaim 'pvc-app' uses correct StorageClass (fast-storage)"
    exit 0
else
    echo "Error: PersistentVolumeClaim 'pvc-app' does not have the correct storage class. Found: '$STORAGE_CLASS', Expected: 'fast-storage'"
    exit 1
fi 