#!/bin/bash

# Validate if the Service 'internal-app' is of type ClusterIP in the 'networking' namespace
SERVICE_TYPE=$(kubectl get service internal-app -n networking -o jsonpath='{.spec.type}' 2>/dev/null)

if [ "$SERVICE_TYPE" = "ClusterIP" ]; then
    echo "Success: Service 'internal-app' is of correct type (ClusterIP)"
    exit 0
else
    echo "Error: Service 'internal-app' is not of the correct type. Found: '$SERVICE_TYPE', Expected: 'ClusterIP'"
    exit 1
fi 