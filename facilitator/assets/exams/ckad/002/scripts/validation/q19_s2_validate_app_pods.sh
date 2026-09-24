#!/bin/bash

# Validate that the required pods exist in the namespace
NS=$(kubectl get namespace network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$NS" == "network-policy" ]]; then
    # Namespace exists, check for the web pod
    WEB_POD=$(kubectl get pod web -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)
    
    if [[ "$WEB_POD" == "web" ]]; then
        # Web pod exists, check for the db pod
        DB_POD=$(kubectl get pod db -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)
        
        if [[ "$DB_POD" == "db" ]]; then
            # DB pod exists, check for the cache pod
            CACHE_POD=$(kubectl get pod cache -n network-policy -o jsonpath='{.metadata.name}' 2>/dev/null)
            
            if [[ "$CACHE_POD" == "cache" ]]; then
                # All required pods exist
                exit 0
            else
                echo "Pod 'cache' does not exist in the 'network-policy' namespace"
                exit 1
            fi
        else
            echo "Pod 'db' does not exist in the 'network-policy' namespace"
            exit 1
        fi
    else
        echo "Pod 'web' does not exist in the 'network-policy' namespace"
        exit 1
    fi
else
    # Namespace does not exist
    echo "Namespace 'network-policy' does not exist"
    exit 1
fi 