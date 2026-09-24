#!/bin/bash

# Validate if the PersistentVolumeClaim 'pvc-app' in namespace 'storage-test' has the correct storage size (500Mi)
STORAGE_SIZE=$(kubectl get pvc pvc-app -n storage-test -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)

if [ "$STORAGE_SIZE" = "500Mi" ]; then
    echo "Success: PersistentVolumeClaim 'pvc-app' has the correct storage size (500Mi)"
    exit 0
else
    echo "Error: PersistentVolumeClaim 'pvc-app' does not have the correct storage size. Found: '$STORAGE_SIZE', Expected: '500Mi'"
    exit 1
fi 