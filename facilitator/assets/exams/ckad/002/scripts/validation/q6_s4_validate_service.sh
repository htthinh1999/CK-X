#!/bin/bash

# Validate that the frontend-svc service exists
SERVICE=$(kubectl get service frontend-svc -n pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$SERVICE" == "frontend-svc" ]]; then
    # Service exists, now check specs
    TYPE=$(kubectl get service frontend-svc -n pod-design -o jsonpath='{.spec.type}' 2>/dev/null)
    PORT=$(kubectl get service frontend-svc -n pod-design -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
    TARGET_PORT=$(kubectl get service frontend-svc -n pod-design -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
    SELECTOR_APP=$(kubectl get service frontend-svc -n pod-design -o jsonpath='{.spec.selector.app}' 2>/dev/null)
    
    if [[ "$TYPE" == "ClusterIP" && "$PORT" == "80" && "$TARGET_PORT" == "80" && "$SELECTOR_APP" == "frontend" ]]; then
        # Service is configured correctly
        exit 0
    else
        echo "Service 'frontend-svc' is not configured correctly."
        echo "Found type: $TYPE (expected: ClusterIP)"
        echo "Found port: $PORT (expected: 80)"
        echo "Found target port: $TARGET_PORT (expected: 80)"
        echo "Found selector app: $SELECTOR_APP (expected: frontend)"
        exit 1
    fi
else
    # Service does not exist
    echo "Service 'frontend-svc' does not exist in the 'pod-design' namespace"
    exit 1
fi 