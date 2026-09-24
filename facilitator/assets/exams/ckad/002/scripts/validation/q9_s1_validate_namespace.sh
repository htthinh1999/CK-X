#!/bin/bash

# Validate that the configuration namespace exists
NS=$(kubectl get namespace configuration -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "configuration" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'configuration' does not exist"
    exit 1
fi 