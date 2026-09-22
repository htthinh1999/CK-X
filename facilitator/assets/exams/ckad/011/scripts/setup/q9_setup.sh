#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Student creates echo-pod. Only ensure namespace.
kubectl create namespace current --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 9"
exit 0
