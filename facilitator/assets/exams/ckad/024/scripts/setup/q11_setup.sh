#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace cargo --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean slate: the student creates the PV, the PVC and the Pod
kubectl -n cargo delete pod ledger-writer --ignore-not-found=true --timeout=60s >/dev/null 2>&1 || true
kubectl -n cargo delete pvc ledger-claim --ignore-not-found=true --timeout=60s >/dev/null 2>&1 || true
kubectl delete pv ledger-pv --ignore-not-found=true --timeout=60s >/dev/null 2>&1 || true

echo "Setup complete for Question 11"
exit 0
