#!/bin/bash

# Get the total number of pods for the deployment
TOTAL_PODS=$(kubectl get deployment broken-deployment -n troubleshooting -o jsonpath='{.spec.replicas}' 2>/dev/null)

# Get the number of running pods for the deployment
RUNNING_PODS=$(kubectl get pods -n troubleshooting -l app=nginx --field-selector=status.phase=Running -o name 2>/dev/null | wc -l)

if [[ "$RUNNING_PODS" -eq "$TOTAL_PODS" && "$TOTAL_PODS" -gt 0 ]]; then
    # All pods are running
    exit 0
else
    # Not all pods are running
    echo "Not all pods are running for 'broken-deployment'. Running pods: $RUNNING_PODS, Expected: $TOTAL_PODS"
    exit 1
fi 