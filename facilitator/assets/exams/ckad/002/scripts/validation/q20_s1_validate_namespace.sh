#!/bin/bash

# Validate that the init-containers namespace exists
NS=$(kubectl get namespace init-containers -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "init-containers" ]]; then
    # Namespace exists
    exit 0
else
    # Namespace does not exist
    echo "Namespace 'init-containers' does not exist"
    exit 1
fi 