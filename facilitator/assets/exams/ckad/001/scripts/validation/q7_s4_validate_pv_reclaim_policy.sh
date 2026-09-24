#!/bin/bash

# Validate if the PersistentVolume 'pv-storage' has the correct reclaim policy (Retain)
RECLAIM_POLICY=$(kubectl get pv pv-storage -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)

if [ "$RECLAIM_POLICY" = "Retain" ]; then
    echo "Success: PersistentVolume 'pv-storage' has the correct reclaim policy (Retain)"
    exit 0
else
    echo "Error: PersistentVolume 'pv-storage' does not have the correct reclaim policy. Found: '$RECLAIM_POLICY', Expected: 'Retain'"
    exit 1
fi 