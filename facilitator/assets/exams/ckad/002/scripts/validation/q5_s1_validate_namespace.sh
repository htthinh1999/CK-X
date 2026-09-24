#!/bin/bash

# Validate that the pod-design namespace exists
NS=$(kubectl get namespace pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "pod-design" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'pod-design' does not exist"
    exit 1
fi 