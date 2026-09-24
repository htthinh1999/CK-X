#!/bin/bash

# Validate that the app-secret Secret exists
SECRET=$(kubectl get secret app-secret -n configuration -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$SECRET" == "app-secret" ]]; then
    # Secret exists, now check data
    # Get base64 encoded values
    DB_USER_B64=$(kubectl get secret app-secret -n configuration -o jsonpath='{.data.DB_USER}' 2>/dev/null)
    DB_PASSWORD_B64=$(kubectl get secret app-secret -n configuration -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null)
    
    # Decode base64 values
    DB_USER=$(echo $DB_USER_B64 | base64 -d 2>/dev/null)
    DB_PASSWORD=$(echo $DB_PASSWORD_B64 | base64 -d 2>/dev/null)
    
    if [[ "$DB_USER" == "admin" && "$DB_PASSWORD" == "s3cr3t" ]]; then
        # Secret has correct data
        exit 0
    else
        echo "Secret 'app-secret' does not have correct data."
        echo "Found DB_USER: $DB_USER (expected: admin)"
        echo "Found DB_PASSWORD: $DB_PASSWORD (expected: s3cr3t)"
        exit 1
    fi
else
    # Secret does not exist
    echo "Secret 'app-secret' does not exist in the 'configuration' namespace"
    exit 1
fi 