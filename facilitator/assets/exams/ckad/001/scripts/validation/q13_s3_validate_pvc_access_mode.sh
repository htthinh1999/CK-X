#!/bin/bash

# Validate if PersistentVolumeClaim has correct access mode
ACCESS_MODE=$(kubectl get pvc pvc-app -n storage-test -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)

if [ "$ACCESS_MODE" = "ReadWriteOnce" ]; then
    echo "Success: PersistentVolumeClaim 'pvc-app' has the correct access mode (ReadWriteOnce)"
    exit 0
else
    echo "Error: PersistentVolumeClaim 'pvc-app' does not have the correct access mode. Found: '$ACCESS_MODE', Expected: 'ReadWriteOnce'"
    exit 1
fi  