#!/bin/bash

# Validate that the app-config ConfigMap exists
CONFIGMAP=$(kubectl get configmap app-config -n configuration -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$CONFIGMAP" == "app-config" ]]; then
    # ConfigMap exists, now check data
    DB_HOST=$(kubectl get configmap app-config -n configuration -o jsonpath='{.data.DB_HOST}' 2>/dev/null)
    DB_PORT=$(kubectl get configmap app-config -n configuration -o jsonpath='{.data.DB_PORT}' 2>/dev/null)
    DB_NAME=$(kubectl get configmap app-config -n configuration -o jsonpath='{.data.DB_NAME}' 2>/dev/null)
    
    if [[ "$DB_HOST" == "mysql" && "$DB_PORT" == "3306" && "$DB_NAME" == "myapp" ]]; then
        # ConfigMap has correct data
        exit 0
    else
        echo "ConfigMap 'app-config' does not have correct data."
        echo "Found DB_HOST: $DB_HOST (expected: mysql)"
        echo "Found DB_PORT: $DB_PORT (expected: 3306)"
        echo "Found DB_NAME: $DB_NAME (expected: myapp)"
        exit 1
    fi
else
    # ConfigMap does not exist
    echo "ConfigMap 'app-config' does not exist in the 'configuration' namespace"
    exit 1
fi 