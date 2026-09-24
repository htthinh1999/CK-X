#!/bin/bash

# Validate that the readiness probe is configured correctly
POD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "probes-pod" ]]; then
    # Pod exists, now check readiness probe
    # Check readiness probe type
    READINESS_TYPE=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].readinessProbe.httpGet}' 2>/dev/null)
    
    # Check readiness probe path
    READINESS_PATH=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null)
    
    # Check readiness probe port
    READINESS_PORT=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.port}' 2>/dev/null)
    
    # Check readiness probe initialDelaySeconds
    READINESS_DELAY=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].readinessProbe.initialDelaySeconds}' 2>/dev/null)
    
    # Check readiness probe periodSeconds
    READINESS_PERIOD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].readinessProbe.periodSeconds}' 2>/dev/null)
    
    if [[ "$READINESS_PATH" == "/" && "$READINESS_PORT" == "80" && "$READINESS_DELAY" == "5" && "$READINESS_PERIOD" == "3" ]]; then
        # Readiness probe is configured correctly
        exit 0
    else
        echo "Readiness probe is not configured correctly."
        echo "Found path: $READINESS_PATH (expected: /)"
        echo "Found port: $READINESS_PORT (expected: 80)"
        echo "Found initialDelaySeconds: $READINESS_DELAY (expected: 5)"
        echo "Found periodSeconds: $READINESS_PERIOD (expected: 3)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'probes-pod' does not exist in the 'observability' namespace"
    exit 1
fi 