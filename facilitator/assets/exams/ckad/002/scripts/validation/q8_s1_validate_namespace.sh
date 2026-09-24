#!/bin/bash

# Validate that the pod-lifecycle namespace exists
NS=$(kubectl get namespace pod-lifecycle -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "pod-lifecycle" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'pod-lifecycle' does not exist"
    exit 1
fi 