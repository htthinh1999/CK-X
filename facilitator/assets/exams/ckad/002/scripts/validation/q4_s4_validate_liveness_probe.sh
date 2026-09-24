#!/bin/bash

# Validate that the liveness probe is configured correctly
POD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "health-check-pod" ]]; then
    # Pod exists, now check if it has a liveness probe
    # Check if it's using httpGet
    HTTP_GET=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].livenessProbe.httpGet}' 2>/dev/null)
    
    # Check port
    PORT=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null)
    
    # Check initial delay
    INITIAL_DELAY=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
    
    # Check period
    PERIOD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
    
    # Check failure threshold
    FAILURE_THRESHOLD=$(kubectl get pod health-check-pod -n health-checks -o jsonpath='{.spec.containers[0].livenessProbe.failureThreshold}' 2>/dev/null)
    
    if [[ "$HTTP_GET" != "" && 
          "$PORT" == "80" && 
          "$INITIAL_DELAY" == "15" && 
          "$PERIOD" == "5" && 
          "$FAILURE_THRESHOLD" == "3" ]]; then
        # Liveness probe is configured correctly
        exit 0
    else
        echo "Liveness probe is not configured correctly."
        echo "Found port: $PORT (expected: 80)"
        echo "Found initial delay: $INITIAL_DELAY (expected: 15)"
        echo "Found period: $PERIOD (expected: 5)"
        echo "Found failure threshold: $FAILURE_THRESHOLD (expected: 3)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'health-check-pod' does not exist in the 'health-checks' namespace"
    exit 1
fi 