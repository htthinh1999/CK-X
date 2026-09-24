#!/bin/bash

# Validate that the cache-policy network policy exists with correct configurations
POLICY=$(kubectl get networkpolicy cache-policy -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POLICY" == "cache-policy" ]]; then
    # Network policy exists, check that it applies to the cache pod
    POD_SELECTOR=$(kubectl get networkpolicy cache-policy -n network-policy -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
    
    if [[ "$POD_SELECTOR" == "cache" ]]; then
        # Policy applies to cache pod, check ingress rules
        INGRESS_RULES=$(kubectl get networkpolicy cache-policy -n network-policy -o jsonpath='{.spec.ingress[0]}' 2>/dev/null)
        
        if [[ "$INGRESS_RULES" != "" ]]; then
            # Has ingress rules, check from selector
            FROM_SELECTOR=$(kubectl get networkpolicy cache-policy -n network-policy -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null)
            
            if [[ "$FROM_SELECTOR" == "web" ]]; then
                # Allows traffic from web pod, check port
                PORT=$(kubectl get networkpolicy cache-policy -n network-policy -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
                
                if [[ "$PORT" == "6379" ]]; then
                    # Allows traffic on port 6379 (Redis)
                    exit 0
                else
                    echo "Network policy 'cache-policy' specifies incorrect port. Found: $PORT (expected: 6379)"
                    exit 1
                fi
            else
                echo "Network policy 'cache-policy' allows traffic from incorrect pods. Found: $FROM_SELECTOR (expected: web)"
                exit 1
            fi
        else
            echo "Network policy 'cache-policy' does not have ingress rules"
            exit 1
        fi
    else
        echo "Network policy 'cache-policy' does not apply to the cache pod. Found selector: $POD_SELECTOR"
        exit 1
    fi
else
    # Network policy does not exist
    echo "Network policy 'cache-policy' does not exist in the 'network-policy' namespace"
    exit 1
fi 