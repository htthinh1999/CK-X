#!/bin/bash

# Validate that the pre-stop hook is configured correctly
POD=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "lifecycle-pod" ]]; then
    # Pod exists, now check if it has a pre-stop hook
    # Check if it has exec pre-stop hook
    PRE_STOP_EXEC=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.preStop.exec}' 2>/dev/null)
    
    if [[ "$PRE_STOP_EXEC" != "" ]]; then
        # Has exec pre-stop hook, check command
        COMMAND=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.preStop.exec.command}' 2>/dev/null)
        
        if [[ "$COMMAND" == *"sh"* && "$COMMAND" == *"-c"* && "$COMMAND" == *"sleep"* ]]; then
            # Pre-stop hook has the sleep command, which is a common pattern
            exit 0
        else
            echo "Pre-stop hook does not have the expected command."
            echo "Found command: $COMMAND"
            echo "Expected a command containing 'sleep' to allow graceful shutdown."
            exit 1
        fi
    else
        # No exec pre-stop hook, check http pre-stop hook
        PRE_STOP_HTTP=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.preStop.httpGet}' 2>/dev/null)
        
        if [[ "$PRE_STOP_HTTP" != "" ]]; then
            # Has http pre-stop hook, this is acceptable as well
            exit 0
        else
            echo "Pod 'lifecycle-pod' does not have a pre-stop hook"
            exit 1
        fi
    fi
else
    # Pod does not exist
    echo "Pod 'lifecycle-pod' does not exist in the 'pod-lifecycle' namespace"
    exit 1
fi 