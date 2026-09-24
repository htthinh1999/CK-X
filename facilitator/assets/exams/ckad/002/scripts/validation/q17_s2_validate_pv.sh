#!/bin/bash

# Validate that the db-pv PersistentVolume exists
PV=$(kubectl get pv db-pv -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$PV" == "db-pv" ]]; then
    # PV exists, now check specs
    
    # Check capacity
    CAPACITY=$(kubectl get pv db-pv -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)
    
    # Check access mode
    ACCESS_MODE=$(kubectl get pv db-pv -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
    
    # Check host path
    HOST_PATH=$(kubectl get pv db-pv -o jsonpath='{.spec.hostPath.path}' 2>/dev/null)
    
    # Check reclaim policy
    RECLAIM_POLICY=$(kubectl get pv db-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)
    
    if [[ "$CAPACITY" == "1Gi" && 
          "$ACCESS_MODE" == "ReadWriteOnce" && 
          "$HOST_PATH" == "/mnt/data" && 
          "$RECLAIM_POLICY" == "Retain" ]]; then
        # PV is configured correctly
        exit 0
    else
        echo "PersistentVolume 'db-pv' is not configured correctly."
        echo "Found capacity: $CAPACITY (expected: 1Gi)"
        echo "Found access mode: $ACCESS_MODE (expected: ReadWriteOnce)"
        echo "Found host path: $HOST_PATH (expected: /mnt/data)"
        echo "Found reclaim policy: $RECLAIM_POLICY (expected: Retain)"
        exit 1
    fi
else
    # PV does not exist
    echo "PersistentVolume 'db-pv' does not exist"
    exit 1
fi 