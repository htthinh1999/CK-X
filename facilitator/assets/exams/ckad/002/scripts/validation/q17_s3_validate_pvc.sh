#!/bin/bash

# Validate that the db-pvc PersistentVolumeClaim exists
PVC=$(kubectl get pvc db-pvc -n state -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$PVC" == "db-pvc" ]]; then
    # PVC exists, now check specs
    
    # Check access mode
    ACCESS_MODE=$(kubectl get pvc db-pvc -n state -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
    
    # Check requested storage
    STORAGE=$(kubectl get pvc db-pvc -n state -o jsonpath='{.spec.resources.requests.storage}' 2>/dev/null)
    
    if [[ "$ACCESS_MODE" == "ReadWriteOnce" && "$STORAGE" == "500Mi" ]]; then
        # PVC is configured correctly
        exit 0
    else
        echo "PersistentVolumeClaim 'db-pvc' is not configured correctly."
        echo "Found access mode: $ACCESS_MODE (expected: ReadWriteOnce)"
        echo "Found requested storage: $STORAGE (expected: 500Mi)"
        exit 1
    fi
else
    # PVC does not exist
    echo "PersistentVolumeClaim 'db-pvc' does not exist in the 'state' namespace"
    exit 1
fi 