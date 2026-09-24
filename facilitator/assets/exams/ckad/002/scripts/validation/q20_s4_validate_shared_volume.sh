#!/bin/bash

# Validate that the shared volume is configured correctly
# Check if volume exists
VOLUME_NAME=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.volumes[?(@.name=="shared")].name}' 2>/dev/null)

if [[ "$VOLUME_NAME" == "shared" ]]; then
    # Volume exists, now check if it's mounted in both containers
    # Check main container mount
    MAIN_CONTAINER_MOUNT=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.containers[0].volumeMounts[?(@.name=="shared")].mountPath}' 2>/dev/null)
    
    # Check init container mount
    INIT_CONTAINER_MOUNT=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.initContainers[0].volumeMounts[?(@.name=="shared")].mountPath}' 2>/dev/null)
    
    if [[ "$MAIN_CONTAINER_MOUNT" == "/shared" && "$INIT_CONTAINER_MOUNT" == "/shared" ]]; then
        # Both containers have the volume mounted at the correct path
        exit 0
    else
        echo "Volume mounts are not configured correctly."
        echo "Main container mount path: $MAIN_CONTAINER_MOUNT (expected: /shared)"
        echo "Init container mount path: $INIT_CONTAINER_MOUNT (expected: /shared)"
        exit 1
    fi
else
    # Try checking with different volume names, as the question doesn't specify the exact name
    VOLUMES=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.volumes[*].name}' 2>/dev/null)
    
    if [[ "$VOLUMES" != "" ]]; then
        # There are volumes, check if any are mounted in both containers
        # Check main container mounts
        MAIN_CONTAINER_MOUNTS=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
        
        # Check init container mounts
        INIT_CONTAINER_MOUNTS=$(kubectl get pod app-with-init -n init-containers -o jsonpath='{.spec.initContainers[0].volumeMounts[*].mountPath}' 2>/dev/null)
        
        if [[ "$MAIN_CONTAINER_MOUNTS" == *"/shared"* && "$INIT_CONTAINER_MOUNTS" == *"/shared"* ]]; then
            # Both containers have a volume mounted at /shared
            exit 0
        else
            echo "Shared volume is not configured correctly. Both containers should mount the same volume at '/shared'."
            echo "Main container mounts: $MAIN_CONTAINER_MOUNTS"
            echo "Init container mounts: $INIT_CONTAINER_MOUNTS"
            exit 1
        fi
    else
        echo "No shared volume found in pod 'app-with-init'"
        exit 1
    fi
fi 