#!/bin/bash

# Validate that the health-checks namespace exists
NS=$(kubectl get namespace health-checks -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "health-checks" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'health-checks' does not exist"
    exit 1
fi 