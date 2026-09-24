#!/bin/bash

# Validate that the multi-container namespace exists
NS=$(kubectl get namespace multi-container -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "multi-container" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'multi-container' does not exist"
    exit 1
fi 