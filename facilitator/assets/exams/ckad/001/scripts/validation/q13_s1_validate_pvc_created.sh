#!/bin/bash

# Validate if the PersistentVolumeClaim 'pvc-app' exists in the 'storage-test' namespace
if kubectl get pvc pvc-app -n storage-test &> /dev/null; then
    echo "Success: PersistentVolumeClaim 'pvc-app' exists in namespace 'storage-test'"
    exit 0
else
    echo "Error: PersistentVolumeClaim 'pvc-app' does not exist in namespace 'storage-test'"
    exit 1
fi 