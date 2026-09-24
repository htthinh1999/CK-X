#!/bin/bash

# Validate that the liveness probe is configured correctly
POD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "probes-pod" ]]; then
    # Pod exists, now check liveness probe
    # Check liveness probe type
    LIVENESS_TYPE=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].livenessProbe.httpGet}' 2>/dev/null)
    
    # Check liveness probe path
    LIVENESS_PATH=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null)
    
    # Check liveness probe port
    LIVENESS_PORT=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}' 2>/dev/null)
    
    # Check liveness probe initialDelaySeconds
    LIVENESS_DELAY=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].livenessProbe.initialDelaySeconds}' 2>/dev/null)
    
    # Check liveness probe periodSeconds
    LIVENESS_PERIOD=$(kubectl get pod probes-pod -n observability -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}' 2>/dev/null)
    
    if [[ "$LIVENESS_PATH" == "/healthz" && "$LIVENESS_PORT" == "80" && "$LIVENESS_DELAY" == "10" && "$LIVENESS_PERIOD" == "5" ]]; then
        # Liveness probe is configured correctly
        exit 0
    else
        echo "Liveness probe is not configured correctly."
        echo "Found path: $LIVENESS_PATH (expected: /healthz)"
        echo "Found port: $LIVENESS_PORT (expected: 80)"
        echo "Found initialDelaySeconds: $LIVENESS_DELAY (expected: 10)"
        echo "Found periodSeconds: $LIVENESS_PERIOD (expected: 5)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'probes-pod' does not exist in the 'observability' namespace"
    exit 1
fi 