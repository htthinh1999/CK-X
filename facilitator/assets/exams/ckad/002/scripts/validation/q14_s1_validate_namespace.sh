#!/bin/bash

# Validate that the security namespace exists
NS=$(kubectl get namespace security -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "security" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'security' does not exist"
    exit 1
fi 