#!/bin/bash

# Validate that the pod mounts the PVC correctly
POD=$(kubectl get pod db-pod -n state -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "db-pod" ]]; then
    # Pod exists, now check if it mounts the PVC
    # First check if the pod has a volume with the PVC
    PVC_VOLUME=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim.claimName=="db-pvc")].persistentVolumeClaim.claimName}' 2>/dev/null)
    
    # Then check if the volume is mounted at the correct path
    MOUNT_PATH=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
    
    if [[ "$PVC_VOLUME" == "db-pvc" && "$MOUNT_PATH" == "/var/lib/mysql" ]]; then
        # Pod mounts the PVC correctly
        exit 0
    else
        echo "Pod 'db-pod' does not mount PVC 'db-pvc' correctly at '/var/lib/mysql'"
        echo "Found PVC volume: $PVC_VOLUME"
        echo "Found mount path: $MOUNT_PATH"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'db-pod' does not exist in the 'state' namespace"
    exit 1
fi 