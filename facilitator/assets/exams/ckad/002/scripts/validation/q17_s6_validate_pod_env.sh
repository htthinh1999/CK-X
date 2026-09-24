#!/bin/bash

# Validate that the pod has correct environment variables
POD=$(kubectl get pod db-pod -n state -o jsonpath='{.metadata.name}' 2>/dev/null)

if [[ "$POD" == "db-pod" ]]; then
    # Pod exists, now check environment variables
    
    # Get environment variables
    ROOT_PASSWORD=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].env[?(@.name=="MYSQL_ROOT_PASSWORD")].value}' 2>/dev/null)
    DATABASE=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].env[?(@.name=="MYSQL_DATABASE")].value}' 2>/dev/null)
    USER=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].env[?(@.name=="MYSQL_USER")].value}' 2>/dev/null)
    PASSWORD=$(kubectl get pod db-pod -n state -o jsonpath='{.spec.containers[0].env[?(@.name=="MYSQL_PASSWORD")].value}' 2>/dev/null)
    
    if [[ "$ROOT_PASSWORD" == "rootpassword" && 
          "$DATABASE" == "mydb" && 
          "$USER" == "myuser" && 
          "$PASSWORD" == "mypassword" ]]; then
        # Pod has correct environment variables
        exit 0
    else
        echo "Pod 'db-pod' does not have correct environment variables."
        echo "Found MYSQL_ROOT_PASSWORD: $ROOT_PASSWORD (expected: rootpassword)"
        echo "Found MYSQL_DATABASE: $DATABASE (expected: mydb)"
        echo "Found MYSQL_USER: $USER (expected: myuser)"
        echo "Found MYSQL_PASSWORD: $PASSWORD (expected: mypassword)"
        exit 1
    fi
else
    # Pod does not exist
    echo "Pod 'db-pod' does not exist in the 'state' namespace"
    exit 1
fi 