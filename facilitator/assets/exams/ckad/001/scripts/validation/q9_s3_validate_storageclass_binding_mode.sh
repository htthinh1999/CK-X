#!/bin/bash

# Validate if the StorageClass 'slow-storage' has the correct volumeBindingMode
BINDING_MODE=$(kubectl get storageclass fast-storage -o jsonpath='{.volumeBindingMode}' 2>/dev/null)

if [ "$BINDING_MODE" = "WaitForFirstConsumer" ]; then
    echo "Success: StorageClass 'fast-storage' has the correct volumeBindingMode (WaitForFirstConsumer)"
    exit 0
else
    echo "Error: StorageClass 'fast-storage' does not have the correct volumeBindingMode. Found: '$BINDING_MODE', Expected: 'WaitForFirstConsumer'"
    exit 1
fi 