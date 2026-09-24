#!/bin/bash

# Validate that the frontend deployment exists
DEPLOYMENT=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$DEPLOYMENT" == "frontend" ]]; then
    # Deployment exists, now check specs
    
    # Check image
    IMAGE=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
    
    # Check labels
    APP_LABEL=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.metadata.labels.app}' 2>/dev/null)
    TIER_LABEL=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.metadata.labels.tier}' 2>/dev/null)
    
    # Check pod labels
    POD_APP_LABEL=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
    POD_TIER_LABEL=$(kubectl get deployment frontend -n pod-design -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null)
    
    if [[ "$IMAGE" == "nginx:1.19.0" && 
          "$APP_LABEL" == "frontend" && 
          "$TIER_LABEL" == "frontend" && 
          "$POD_APP_LABEL" == "frontend" && 
          "$POD_TIER_LABEL" == "frontend" ]]; then
        # All specifications are correct
        exit 0
    else
        echo "Deployment 'frontend' does not have correct specifications."
        echo "Found image: $IMAGE (expected: nginx:1.19.0)"
        echo "Found deployment app label: $APP_LABEL (expected: frontend)"
        echo "Found deployment tier label: $TIER_LABEL (expected: frontend)"
        echo "Found pod app label: $POD_APP_LABEL (expected: frontend)"
        echo "Found pod tier label: $POD_TIER_LABEL (expected: frontend)"
        exit 1
    fi
else
    # Deployment does not exist
    echo "Deployment 'frontend' does not exist in the 'pod-design' namespace"
    exit 1
fi 