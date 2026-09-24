#!/bin/bash

# Validate that the state namespace exists
NS=$(kubectl get namespace state -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "state" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'state' does not exist"
    exit 1
fi 