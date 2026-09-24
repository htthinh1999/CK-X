#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace wharf --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean slate: the student creates the LimitRange, the ResourceQuota and the Pod
kubectl -n wharf delete pod forklift --ignore-not-found=true --timeout=60s >/dev/null 2>&1 || true
kubectl -n wharf delete resourcequota wharf-quota --ignore-not-found=true >/dev/null 2>&1 || true
kubectl -n wharf delete limitrange crate-defaults --ignore-not-found=true >/dev/null 2>&1 || true

echo "Setup complete for Question 16"
exit 0
