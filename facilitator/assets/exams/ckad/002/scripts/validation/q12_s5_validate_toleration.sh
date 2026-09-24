#!/bin/bash

# Validate that the pod has the correct toleration
POD=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "scheduled-pod" ]]; then
    # Pod exists, check if it has the required toleration
    # We need to get the whole tolerations array and check it with grep
    TOLERATIONS=$(kubectl get pod scheduled-pod -n pod-scheduling -o jsonpath='{.spec.tolerations}' 2>/dev/null)
    
    if [[ "$TOLERATIONS" == *"key\":\"node-role.kubernetes.io/master"* || 
          "$TOLERATIONS" == *"key\":\"node-role.kubernetes.io/control-plane"* ]]; then
        # Check for the effect
        if [[ "$TOLERATIONS" == *"effect\":\"NoSchedule"* ]]; then
            # Pod has the correct toleration
            exit 0
        else
            echo "Pod 'scheduled-pod' has a master/control-plane toleration but without the NoSchedule effect"
            exit 1
        fi
    else
        echo "Pod 'scheduled-pod' does not have the required toleration for master/control-plane nodes"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'scheduled-pod' does not exist in the 'pod-scheduling' namespace"
    exit 1
fi 