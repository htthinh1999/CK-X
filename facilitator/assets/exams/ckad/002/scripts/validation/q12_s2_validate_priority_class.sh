#!/bin/bash

# Validate that the high-priority PriorityClass exists
PC=$(kubectl get priorityclass high-priority -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$PC" == "high-priority" ]]; then
    # PriorityClass exists, check the value
    VALUE=$(kubectl get priorityclass high-priority -o jsonpath='{.value}' 2>/dev/null)
    
    if [[ "$VALUE" == "1000" ]]; then
        # PriorityClass has correct value
        exit 0
    else
        echo "PriorityClass 'high-priority' exists but has incorrect priority value. Found: $VALUE (expected: 1000)"
        exit 1
    fi
else
    # PriorityClass does not exist
    echo "PriorityClass 'high-priority' does not exist"
    exit 1
fi 