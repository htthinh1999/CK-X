#!/bin/bash

# Validate that the startup probe is configured correctly
POD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "health-check-pod" ]]; then
    # Pod exists, now check if it has a startup probe
    # Check if it's using httpGet
    HTTP_GET=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].startupProbe.httpGet}' 2>/dev/null)
    
    # Check port
    PORT=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].startupProbe.httpGet.port}' 2>/dev/null)
    
    # Check initial delay
    INITIAL_DELAY=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].startupProbe.initialDelaySeconds}' 2>/dev/null)
    
    # Check period
    PERIOD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].startupProbe.periodSeconds}' 2>/dev/null)
    
    # Check failure threshold
    FAILURE_THRESHOLD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].startupProbe.failureThreshold}' 2>/dev/null)
    
    if [[ "$HTTP_GET" != "" && 
          "$PORT" == "80" && 
          "$INITIAL_DELAY" == "10" && 
          "$PERIOD" == "3" && 
          "$FAILURE_THRESHOLD" == "3" ]]; then
        # Startup probe is configured correctly
        exit 0
    else
        echo "Startup probe is not configured correctly."
        echo "Found port: $PORT (expected: 80)"
        echo "Found initial delay: $INITIAL_DELAY (expected: 10)"
        echo "Found period: $PERIOD (expected: 3)"
        echo "Found failure threshold: $FAILURE_THRESHOLD (expected: 3)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'health-check-pod' does not exist in the 'health-checks' namespace"
    exit 1
fi 