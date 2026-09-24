#!/bin/bash

# Validate that the pod has the correct termination grace period
POD=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "lifecycle-pod" ]]; then
    # Pod exists, now check if it has a termination grace period
    GRACE_PERIOD=$(kubectl get pod lifecycle-pod -n pod-lifecycle -o jsonpath='{.spec.terminationGracePeriodSeconds}' 2>/dev/null)
    
    if [[ "$GRACE_PERIOD" == "30" ]]; then
        # Grace period is correctly set to 30 seconds
        exit 0
    elif [[ "$GRACE_PERIOD" == "" ]]; then
        echo "Pod 'lifecycle-pod' does not have a termination grace period specified (using default of 30 seconds)"
        exit 1
    else
        echo "Pod 'lifecycle-pod' has incorrect termination grace period. Found: $GRACE_PERIOD (expected: 45)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'lifecycle-pod' does not exist in the 'pod-lifecycle' namespace"
    exit 1
fi 