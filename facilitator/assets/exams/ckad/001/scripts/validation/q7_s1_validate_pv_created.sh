#!/bin/bash

# Validate if the PersistentVolume 'pv-storage' exists
if kubectl get pv pv-storage &> /dev/null; then
    echo "Success: PersistentVolume 'pv-storage' exists"
    exit 0
else
    echo "Error: PersistentVolume 'pv-storage' does not exist"
    exit 1
fi 