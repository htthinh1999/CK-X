#!/bin/bash

# Validate that the web-app deployment exists
DEPLOYMENT=$(kubectl get deployment web-app -n services -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$DEPLOYMENT" == "web-app" ]]; then
    # Deployment exists, now check specs
    
    # Check image
    IMAGE=$(kubectl get deployment web-app -n services -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
    
    # Check replicas
    REPLICAS=$(kubectl get deployment web-app -n services -o jsonpath='{.spec.replicas}' 2>/dev/null)
    
    # Check pod labels
    APP_LABEL=$(kubectl get deployment web-app -n services -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx:alpine" && "$REPLICAS" == "3" && "$APP_LABEL" == "web" ]]; then
        # Deployment is configured correctly
        exit 0
    else
        echo "Deployment 'web-app' is not configured correctly."
        echo "Found image: $IMAGE (expected: nginx:alpine)"
        echo "Found replicas: $REPLICAS (expected: 3)"
        echo "Found app label: $APP_LABEL (expected: web)"
        exit 1
    fi
else
    # Deployment does not exist
    echo "Deployment 'web-app' does not exist in the 'services' namespace"
    exit 1
fi 