#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=archive
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean slate: the student creates both objects
kubectl -n "$NS" delete deployment plate-scanner --ignore-not-found >/dev/null 2>&1 || true
kubectl -n "$NS" delete pvc plate-archive --ignore-not-found --wait=false >/dev/null 2>&1 || true

echo "Setup complete for Question 15"
exit 0
