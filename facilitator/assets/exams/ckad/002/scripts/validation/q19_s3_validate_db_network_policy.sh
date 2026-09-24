#!/bin/bash

# Validate that the db-policy network policy exists with correct configurations
POLICY=$(kubectl get networkpolicy db-policy -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POLICY" == "db-policy" ]]; then
    # Network policy exists, check that it applies to the db pod
    POD_SELECTOR=$(kubectl get networkpolicy db-policy -n network-policy -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
    
    if [[ "$POD_SELECTOR" == "db" ]]; then
        # Policy applies to db pod, check ingress rules
        INGRESS_RULES=$(kubectl get networkpolicy db-policy -n network-policy -o jsonpath='{.spec.ingress[0]}' 2>/dev/null)
        
        if [[ "$INGRESS_RULES" != "" ]]; then
            # Has ingress rules, check from selector
            FROM_SELECTOR=$(kubectl get networkpolicy db-policy -n network-policy -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.app}' 2>/dev/null)
            
            if [[ "$FROM_SELECTOR" == "web" ]]; then
                # Allows traffic from web pod, check port
                PORT=$(kubectl get networkpolicy db-policy -n network-policy -o jsonpath='{.spec.ingress[0].ports[0].port}' 2>/dev/null)
                
                if [[ "$PORT" == "5432" ]]; then
                    # Allows traffic on port 5432 (PostgreSQL)
                    exit 0
                else
                    echo "Network policy 'db-policy' specifies incorrect port. Found: $PORT (expected: 5432)"
                    exit 1
                fi
            else
                echo "Network policy 'db-policy' allows traffic from incorrect pods. Found: $FROM_SELECTOR (expected: web)"
                exit 1
            fi
        else
            echo "Network policy 'db-policy' does not have ingress rules"
            exit 1
        fi
    else
        echo "Network policy 'db-policy' does not apply to the db pod. Found selector: $POD_SELECTOR"
        exit 1
    fi
else
    # Network policy does not exist
    echo "Network policy 'db-policy' does not exist in the 'network-policy' namespace"
    exit 1
fi 