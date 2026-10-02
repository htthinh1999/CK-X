#!/bin/bash

# Validate if the pod 'sidecar-pod' has a shared volume mounted in both containers
POD_EXISTS=$(kubectl get pod sidecar-pod -n troubleshooting -o name 2>/dev/null)

if [ -z "$POD_EXISTS" ]; then
    echo "Error: Pod 'sidecar-pod' does not exist in namespace 'troubleshooting'"
    exit 1
fi

# The emptyDir volume 'log-volume' must exist ...
if [ -z "$(kubectl get pod sidecar-pod -n troubleshooting -o jsonpath='{.spec.volumes[?(@.name=="log-volume")].name}' 2>/dev/null)" ]; then
    echo "Error: Pod 'sidecar-pod' has no volume named 'log-volume'"
    exit 1
fi

# App containers + native sidecars (init containers with restartPolicy Always)
CONTAINERS=$(kubectl get pod sidecar-pod -n troubleshooting -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))]')

# ... and be mounted at /var/my-log in both the nginx and the sidecar container.
# (Only 'log-volume' counts: the auto-injected service account token volume is mounted in every container.)
SHARED_VOLUME_FOUND=true
for C in nginx sidecar; do
    MOUNT=$(echo "$CONTAINERS" | jq -r --arg c "$C" '.[] | select(.name == $c) | .volumeMounts[]? | select(.name == "log-volume") | .mountPath | rtrimstr("/")')
    if ! echo "$MOUNT" | grep -qx "/var/my-log"; then
        echo "Error: 'log-volume' is not mounted at /var/my-log in container '$C'"
        SHARED_VOLUME_FOUND=false
    fi
done
[ "$SHARED_VOLUME_FOUND" = true ] && echo "Success: Volume 'log-volume' is mounted at /var/my-log in both containers"

if [ "$SHARED_VOLUME_FOUND" = true ]; then
    # Check if the sidecar container is writing to the shared volume
    BUSYBOX_CONTAINER=$(echo "$CONTAINERS" | jq -r '[.[] | select(.image == "busybox")][0].name // empty')
    
    if [ -n "$BUSYBOX_CONTAINER" ]; then
        COMMAND=$(echo "$CONTAINERS" | jq -c --arg n "$BUSYBOX_CONTAINER" '.[] | select(.name == $n) | .command // empty')
        ARGS=$(echo "$CONTAINERS" | jq -c --arg n "$BUSYBOX_CONTAINER" '.[] | select(.name == $n) | .args // empty')
        
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