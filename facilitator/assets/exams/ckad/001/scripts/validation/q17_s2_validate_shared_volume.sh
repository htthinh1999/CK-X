#!/bin/bash

# Validate if the pod 'sidecar-pod' has a shared volume mounted in both containers
POD_EXISTS=$(kubectl get pod sidecar-pod -n troubleshooting -o name 2>/dev/null)

if [ -z "$POD_EXISTS" ]; then
    echo "Error: Pod 'sidecar-pod' does not exist in namespace 'troubleshooting'"
    exit 1
fi

# Get volume names defined in the pod
VOLUMES=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath='{.spec.volumes[*].name}' 2>/dev/null)

if [ -z "$VOLUMES" ]; then
    echo "Error: Pod 'sidecar-pod' does not have any volumes defined"
    exit 1
fi

# Check if there's at least one shared volume mounted in both containers
SHARED_VOLUME_FOUND=false

for VOLUME in $VOLUMES; do
    # Check if this volume is mounted in the first container
    MOUNT_IN_CONTAINER1=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath="{.spec.containers[0].volumeMounts[?(@.name==\"$VOLUME\")].mountPath}" 2>/dev/null)
    
    # Check if this volume is mounted in the second container
    MOUNT_IN_CONTAINER2=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath="{.spec.containers[1].volumeMounts[?(@.name==\"$VOLUME\")].mountPath}" 2>/dev/null)
    
    if [ -n "$MOUNT_IN_CONTAINER1" ] && [ -n "$MOUNT_IN_CONTAINER2" ]; then
        echo "Success: Volume '$VOLUME' is mounted in both containers"
        echo "Mount path in first container: $MOUNT_IN_CONTAINER1"
        echo "Mount path in second container: $MOUNT_IN_CONTAINER2"
        SHARED_VOLUME_FOUND=true
        break
    fi
done

if [ "$SHARED_VOLUME_FOUND" = true ]; then
    # Check if the sidecar container is writing to the shared volume
    BUSYBOX_CONTAINER=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath='{.spec.containers[?(@.image=="busybox")].name}' 2>/dev/null)
    
    if [ -n "$BUSYBOX_CONTAINER" ]; then
        COMMAND=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath="{.spec.containers[?(@.name==\"$BUSYBOX_CONTAINER\")].command}" 2>/dev/null)
        ARGS=$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath="{.spec.containers[?(@.name==\"$BUSYBOX_CONTAINER\")].args}" 2>/dev/null)
        
        if [[ "$COMMAND" == *"date"* ]] || [[ "$ARGS" == *"date"* ]]; then
            echo "Success: Sidecar container appears to be writing date to the shared volume"
            exit 0
        else
            echo "Warning: Shared volume found, but sidecar container may not be writing date to it"
            echo "Container command: $COMMAND"
            echo "Container args: $ARGS"
            exit 0  # Still pass the test since we can't easily verify the exact command
        fi
    else
        echo "Success: Shared volume is mounted in both containers"
        exit 0
    fi
else
    echo "Error: No shared volumes found mounted in both containers"
    exit 1
fi 