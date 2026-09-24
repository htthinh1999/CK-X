#!/bin/bash

# Validate that the jobs namespace exists
NS=$(kubectl get namespace jobs -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "jobs" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'jobs' does not exist"
    exit 1
fi 