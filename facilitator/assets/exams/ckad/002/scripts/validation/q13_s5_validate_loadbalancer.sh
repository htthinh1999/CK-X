#!/bin/bash

# Validate that the LoadBalancer service exists
SERVICE=$(kubectl get service web-svc-lb -n services -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$SERVICE" == "web-svc-lb" ]]; then
    # Service exists, now check specs
    
    # Check type
    TYPE=$(kubectl get service web-svc-lb -n services -o jsonpath='{.spec.type}' 2>/dev/null)
    
    # Check port
    PORT=$(kubectl get service web-svc-lb -n services -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
    
    # Check selector
    APP_SELECTOR=$(kubectl get service web-svc-lb -n services -o jsonpath='{.spec.selector.app}' 2>/dev/null)
    
    if [[ "$TYPE" == "LoadBalancer" && "$PORT" == "80" && "$APP_SELECTOR" == "web" ]]; then
        # LoadBalancer service is configured correctly
        exit 0
    else
        echo "LoadBalancer service 'web-svc-lb' is not configured correctly."
        echo "Found type: $TYPE (expected: LoadBalancer)"
        echo "Found port: $PORT (expected: 80)"
        echo "Found app selector: $APP_SELECTOR (expected: web)"
        exit 1
    fi
else
    # Service does not exist
    echo "Service 'web-svc-lb' does not exist in the 'services' namespace"
    exit 1
fi 