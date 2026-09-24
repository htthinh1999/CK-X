#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Setup for Question 1: CustomResourceDefinition backups.data.example.com

# Create the cluster-admin namespace referenced by the question if it doesn't exist already
kubectl create namespace cluster-admin --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 1: Environment ready for creating CRD 'backups.data.example.com'"
exit 0
