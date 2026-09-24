#!/bin/bash

# Validate that the pod has the correct DNS policy
POD=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "network-pod" ]]; then
    # Pod exists, check DNS policy
    DNS_POLICY=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.dnsPolicy}' 2>/dev/null)
    
    if [[ "$DNS_POLICY" == "ClusterFirstWithHostNet" ]]; then
        # Pod has correct DNS policy
        exit 0
    else
        echo "Pod 'network-pod' has incorrect DNS policy. Found: $DNS_POLICY (expected: ClusterFirstWithHostNet)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'network-pod' does not exist in the 'pod-networking' namespace"
    exit 1
fi 