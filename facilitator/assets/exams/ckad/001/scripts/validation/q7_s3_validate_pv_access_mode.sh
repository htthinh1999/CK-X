#!/bin/bash

# Validate if the PersistentVolume 'pv-storage' has the correct access mode (ReadWriteOnce)
ACCESS_MODE=$(kubectl get pv pv-storage -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)

if [ "$ACCESS_MODE" = "ReadWriteOnce" ]; then
    echo "Success: PersistentVolume 'pv-storage' has the correct access mode (ReadWriteOnce)"
    exit 0
else
    echo "Error: PersistentVolume 'pv-storage' does not have the correct access mode. Found: '$ACCESS_MODE', Expected: 'ReadWriteOnce'"
    exit 1
fi 