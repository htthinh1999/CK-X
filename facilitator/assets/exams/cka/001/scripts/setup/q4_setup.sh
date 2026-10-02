#!/bin/bash
# Setup for Question 4: Logging setup

# Create monitoring namespace if it doesn't exist
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Remove any existing pod with the same name
kubectl delete pod -n monitoring logger --ignore-not-found=true

# Pull required images in advance to speed up pod creation
kubectl run prefetch-busybox --image=busybox --restart=Never -n monitoring --dry-run=client -o yaml | kubectl apply -f -
kubectl run prefetch-fluentd --image=fluentd --restart=Never -n monitoring --dry-run=client -o yaml | kubectl apply -f -

# Wait for prefetch pods to be created
sleep 5

# Clean up prefetch pods
kubectl delete pod -n monitoring prefetch-busybox --ignore-not-found=true
kubectl delete pod -n monitoring prefetch-fluentd --ignore-not-found=true

exit 0 