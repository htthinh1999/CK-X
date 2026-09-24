#!/bin/bash

# Validate that the services namespace exists
NS=$(kubectl get namespace services -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "services" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'services' does not exist"
    exit 1
fi 