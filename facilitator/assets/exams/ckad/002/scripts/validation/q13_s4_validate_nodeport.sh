#!/bin/bash

# Validate that the NodePort service exists
SERVICE=$(kubectl get service web-svc-nodeport -n services -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$SERVICE" == "web-svc-nodeport" ]]; then
    # Service exists, now check specs
    
    # Check type
    TYPE=$(kubectl get service web-svc-nodeport -n services -o jsonpath='{.spec.type}' 2>/dev/null)
    
    # Check port
    PORT=$(kubectl get service web-svc-nodeport -n services -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
    
    # Check nodePort
    NODE_PORT=$(kubectl get service web-svc-nodeport -n services -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
    
    # Check selector
    APP_SELECTOR=$(kubectl get service web-svc-nodeport -n services -o jsonpath='{.spec.selector.app}' 2>/dev/null)
    
    if [[ "$TYPE" == "NodePort" && "$PORT" == "80" && "$NODE_PORT" == "30080" && "$APP_SELECTOR" == "web" ]]; then
        # NodePort service is configured correctly
        exit 0
    else
        echo "NodePort service 'web-svc-nodeport' is not configured correctly."
        echo "Found type: $TYPE (expected: NodePort)"
        echo "Found port: $PORT (expected: 80)"
        echo "Found nodePort: $NODE_PORT (expected: 30080)"
        echo "Found app selector: $APP_SELECTOR (expected: web)"
        exit 1
    fi
else
    # Service does not exist
    echo "Service 'web-svc-nodeport' does not exist in the 'services' namespace"
    exit 1
fi 