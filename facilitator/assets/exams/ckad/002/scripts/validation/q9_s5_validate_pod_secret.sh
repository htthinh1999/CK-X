#!/bin/bash

# Validate that the pod mounts Secret as a volume
POD=$(kubectl get pod app-pod -n configuration -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "app-pod" ]]; then
    # Pod exists, now check if it mounts Secret as a volume
    # First check if the pod has a volume with the secret
    SECRET_VOLUME=$(kubectl get pod app-pod -n configuration -o jsonpath='{.spec.volumes[?(@.secret.secretName=="app-secret")].secret.secretName}' 2>/dev/null)
    
    # Then check if the volume is mounted at the correct path
    MOUNT_PATH=$(kubectl get pod app-pod -n configuration -o jsonpath='{.spec.containers[0].volumeMounts[?(@.mountPath=="/etc/app-secret")].mountPath}' 2>/dev/null)
    
    if [[ "$SECRET_VOLUME" == "app-secret" && "$MOUNT_PATH" == "/etc/app-secret" ]]; then
        # Pod mounts Secret as a volume at the correct path
        exit 0
    else
        echo "Pod 'app-pod' does not mount Secret 'app-secret' as a volume at '/etc/app-secret'"
        echo "Found secret volume: $SECRET_VOLUME"
        echo "Found mount path: $MOUNT_PATH"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'app-pod' does not exist in the 'configuration' namespace"
    exit 1
fi 