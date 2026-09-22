#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace gatehouse --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# The student creates boom-gate from scratch.
kubectl -n gatehouse delete deployment boom-gate --ignore-not-found --wait=false >/dev/null 2>&1 || true

echo "Setup complete for Question 6"
exit 0
