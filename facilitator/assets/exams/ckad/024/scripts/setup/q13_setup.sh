#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace signal --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Start from a clean slate: the student creates the Pod and the Service
kubectl -n signal delete service foghorn-svc --ignore-not-found=true >/dev/null 2>&1 || true
kubectl -n signal delete pod foghorn --ignore-not-found=true --timeout=60s >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q13 || true
mkdir -p /home/candidate/exam/q13 || true

echo "Setup complete for Question 13"
exit 0
