#!/bin/bash

# Validate if the NetworkPolicy 'allow-traffic' exists in the 'networking' namespace
if kubectl get networkpolicy allow-traffic -n networking &> /dev/null; then
    echo "Success: NetworkPolicy 'allow-traffic' exists in namespace 'networking'"
    exit 0
else
    echo "Error: NetworkPolicy 'allow-traffic' does not exist in namespace 'networking'"
    exit 1
fi 