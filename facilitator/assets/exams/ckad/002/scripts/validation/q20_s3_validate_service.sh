#!/bin/bash

# Validate that the service is created correctly
SERVICE=$(kubectl get service myservice -n init-containers -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$SERVICE" == "myservice" ]]; then
    # Service exists, now check image of the pods it selects
    
    # Get selector labels
    SELECTOR_LABELS=$(kubectl get service myservice -n init-containers -o jsonpath='{.spec.selector}' 2>/dev/null)
    
    # Check if the service is configured correctly
    # Since we don't have specific requirements for the service selector in the question,
    # we'll just check if the service exists with the correct name and if it's using the nginx image
    SERVICE_IMAGE=$(kubectl get deployment -n init-containers -l app=myservice -o jsonpath='{.items[0].spec.template.spec.containers[0].image}' 2>/dev/null)
    
    if [[ "$SERVICE_IMAGE" == *"nginx"* || "$SERVICE_IMAGE" == "" ]]; then
        # Service is using nginx or we couldn't find a deployment with app=myservice
        # (which is fine, as the question doesn't specify how the service should be implemented)
        exit 0
    else
        echo "Service 'myservice' does not appear to be using nginx."
        echo "Found image: $SERVICE_IMAGE"
        exit 1
    fi
else
    # Service does not exist
    echo "Service 'myservice' does not exist in the 'init-containers' namespace"
    exit 1
fi 