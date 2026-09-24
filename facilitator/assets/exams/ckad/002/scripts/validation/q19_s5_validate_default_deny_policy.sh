#!/bin/bash

# Validate that the default-deny network policy exists with correct configurations
POLICY=$(kubectl get networkpolicy default-deny -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POLICY" == "default-deny" ]]; then
    # Network policy exists, check that it applies to all pods
    POD_SELECTOR=$(kubectl get networkpolicy default-deny -n network-policy -o jsonpath='{.spec.podSelector}' 2>/dev/null)
    
    if [[ "$POD_SELECTOR" == "{}" ]]; then
        # Policy applies to all pods, check that it has no ingress rules
        # Count ingress rules, should be 0 or empty
        INGRESS_COUNT=$(kubectl get networkpolicy default-deny -n network-policy -o jsonpath='{.spec.ingress}' 2>/dev/null | grep -o "\[" | wc -l)
        
        if [[ "$INGRESS_COUNT" == "0" || "$INGRESS_COUNT" == "" ]]; then
            # No ingress rules, which means default deny all ingress
            exit 0
        else
            echo "Network policy 'default-deny' has ingress rules, should have none for default deny all"
            exit 1
        fi
    else
        echo "Network policy 'default-deny' does not apply to all pods. Found selector: $POD_SELECTOR (expected empty object '{}')"
        exit 1
    fi
else
    # Network policy does not exist
    echo "Network policy 'default-deny' does not exist in the 'network-policy' namespace"
    exit 1
fi 