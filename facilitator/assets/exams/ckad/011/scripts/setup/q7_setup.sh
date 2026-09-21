#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Student creates pvc-pod (and the sea-pvc it mounts, in Q6). Only ensure namespace.
kubectl create namespace depths --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 7"
exit 0
