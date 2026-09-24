#!/bin/bash

# Validate that the pod has the correct hostname and subdomain
POD=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "network-pod" ]]; then
    # Pod exists, check hostname
    HOSTNAME=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.hostname}' 2>/dev/null)
    
    if [[ "$HOSTNAME" == "custom-host" ]]; then
        # Pod has correct hostname, check subdomain
        SUBDOMAIN=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.subdomain}' 2>/dev/null)
        
        if [[ "$SUBDOMAIN" == "example" ]]; then
            # Pod has correct subdomain
            exit 0
        else
            echo "Pod 'network-pod' has incorrect subdomain. Found: $SUBDOMAIN (expected: example)"
            exit 1
        fi
    else
        echo "Pod 'network-pod' has incorrect hostname. Found: $HOSTNAME (expected: custom-host)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'network-pod' does not exist in the 'pod-networking' namespace"
    exit 1
fi 