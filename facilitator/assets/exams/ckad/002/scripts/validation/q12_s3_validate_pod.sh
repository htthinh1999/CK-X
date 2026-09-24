#!/bin/bash

# Validate that the pod exists and uses the high-priority priority class
POD=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "scheduled-pod" ]]; then
    # Pod exists, check if it uses the priority class
    PRIORITY_CLASS=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.spec.priorityClassName}' 2>/dev/null)
    
    if [[ "$PRIORITY_CLASS" == "high-priority" ]]; then
        # Pod uses correct priority class
        exit 0
    else
        echo "Pod 'scheduled-pod' does not use the 'high-priority' priority class. Found: $PRIORITY_CLASS"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'scheduled-pod' does not exist in the 'pod-scheduling' namespace"
    exit 1
fi 