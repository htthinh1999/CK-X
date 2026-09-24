#!/bin/bash

# Validate that the post-start hook is configured correctly
POD=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "lifecycle-pod" ]]; then
    # Pod exists, now check if it has a post-start hook
    # Check if it has exec post-start hook
    POST_START_EXEC=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.postStart.exec}' 2>/dev/null)
    
    if [[ "$POST_START_EXEC" != "" ]]; then
        # Has exec post-start hook, check command
        COMMAND=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.postStart.exec.command}' 2>/dev/null)
        
        if [[ "$COMMAND" == *"echo"* && "$COMMAND" == *"Welcome to the pod"* && "$COMMAND" == *"/usr/share/nginx/html/welcome.txt"* ]]; then
            # Post-start hook creates the welcome file
            exit 0
        else
            echo "Post-start hook does not create the welcome file correctly."
            echo "Found command: $COMMAND"
            exit 1
        fi
    else
        # No exec post-start hook, check http post-start hook
        POST_START_HTTP=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.containers[0].lifecycle.postStart.httpGet}' 2>/dev/null)
        
        if [[ "$POST_START_HTTP" != "" ]]; then
            # Has http post-start hook
            echo "Post-start hook uses httpGet instead of exec. Expected an exec hook that creates a welcome file."
            exit 1
        else
            echo "Pod 'lifecycle-pod' does not have a post-start hook"
            exit 1
        fi
    fi
else
    # Pod does not exist
    echo "Pod 'lifecycle-pod' does not exist in the 'pod-lifecycle' namespace"
    exit 1
fi 