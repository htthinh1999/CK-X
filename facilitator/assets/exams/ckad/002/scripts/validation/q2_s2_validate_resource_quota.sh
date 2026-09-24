#!/bin/bash

# Validate that the compute-quota ResourceQuota exists with correct limits
QUOTA=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$QUOTA" == "compute-quota" ]]; then
    # ResourceQuota exists, now check if it has correct limits
    
    # Check CPU limit
    CPU=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.spec.hard.cpu}' 2>/dev/null)
    
    # Check memory limit
    MEMORY=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.spec.hard.memory}' 2>/dev/null)
    
    # Check pods limit
    PODS=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
    
    # Check services limit
    SERVICES=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.spec.hard.services}' 2>/dev/null)
    
    # Check PVCs limit
    PVCS=$(kubectl get resourcequota compute-quota -n resource-management -o jsonpath='{.spec.hard.persistentvolumeclaims}' 2>/dev/null)
    
    if [[ "$CPU" == "4" && 
          "$MEMORY" == "8Gi" && 
          "$PODS" == "10" && 
          "$SERVICES" == "5" && 
          "$PVCS" == "5" ]]; then
        # ResourceQuota has correct limits
        exit 0
    else
        echo "ResourceQuota 'compute-quota' does not have correct limits."
        echo "Found CPU limit: $CPU (expected: 4)"
        echo "Found memory limit: $MEMORY (expected: 8Gi)"
        echo "Found pods limit: $PODS (expected: 10)"
        echo "Found services limit: $SERVICES (expected: 5)"
        echo "Found PVCs limit: $PVCS (expected: 5)"
        exit 1
    fi
else
    # ResourceQuota does not exist
    echo "ResourceQuota 'compute-quota' does not exist in the 'resource-management' namespace"
    exit 1
fi 