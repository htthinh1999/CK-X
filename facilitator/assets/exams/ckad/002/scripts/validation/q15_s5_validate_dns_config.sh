#!/bin/bash

# Validate that the pod has the correct DNS config
POD=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "network-pod" ]]; then
    # Pod exists, check if it has DNS config
    DNS_CONFIG=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.dnsConfig}' 2>/dev/null)
    
    if [[ "$DNS_CONFIG" != "" ]]; then
        # Pod has DNS config, check nameservers
        NAMESERVERS=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.dnsConfig.nameservers}' 2>/dev/null)
        
        if [[ "$NAMESERVERS" == *"8.8.8.8"* && "$NAMESERVERS" == *"8.8.4.4"* ]]; then
            # Check searches
            SEARCHES=$(kubectl get pod network-pod -n pod-networking -o jsonpath='{.spec.dnsConfig.searches}' 2>/dev/null)
            
            if [[ "$SEARCHES" == *"example.com"* ]]; then
                # Pod has correct DNS config
                exit 0
            else
                echo "Pod 'network-pod' has incorrect DNS config searches. Expected to include 'example.com'"
                exit 1
            fi
        else
            echo "Pod 'network-pod' has incorrect DNS config nameservers. Expected to include 8.8.8.8 and 8.8.4.4"
            exit 1
        fi
    else
        echo "Pod 'network-pod' does not have DNS config"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'network-pod' does not exist in the 'pod-networking' namespace"
    exit 1
fi 