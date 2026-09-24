#!/bin/bash

# Validate that the observability namespace exists
NS=$(kubectl get namespace observability -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "observability" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'observability' does not exist"
    exit 1
fi 