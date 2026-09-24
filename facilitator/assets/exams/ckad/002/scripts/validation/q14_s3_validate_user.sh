#!/bin/bash

# Validate that the secure-app pod runs as non-root user (UID 1000)
POD_SECURITY_CONTEXT=$(kubectl get pod secure-app -n security -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)

if [[ "$POD_SECURITY_CONTEXT" == "1000" ]]; then
    # Pod runs with UID 1000
    exit 0
else
    # Not running as UID 1000 at pod level, check container level
    CONTAINER_SECURITY_CONTEXT=$(kubectl get pod secure-app -n security -o jsonpath='{.spec.containers[0].securityContext.runAsUser}' 2>/dev/null)
    
    if [[ "$CONTAINER_SECURITY_CONTEXT" == "1000" ]]; then
        # Container runs with UID 1000
        exit 0
    else
        echo "Pod 'secure-app' does not run as UID 1000. Found pod: $POD_SECURITY_CONTEXT, container: $CONTAINER_SECURITY_CONTEXT"
        exit 1
    fi
fi 