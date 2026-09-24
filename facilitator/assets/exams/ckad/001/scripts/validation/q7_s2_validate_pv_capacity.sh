#!/bin/bash

# Validate if the PersistentVolume 'pv-storage' has the correct capacity (1Gi)
CAPACITY=$(kubectl get pv pv-storage -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)

if [ "$CAPACITY" = "1Gi" ]; then
    echo "Success: PersistentVolume 'pv-storage' has the correct capacity (1Gi)"
    exit 0
else
    echo "Error: PersistentVolume 'pv-storage' does not have the correct capacity. Found: '$CAPACITY', Expected: '1Gi'"
    exit 1
fi 