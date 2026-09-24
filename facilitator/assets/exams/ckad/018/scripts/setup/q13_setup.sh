#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace cadence --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod shared-process-pod -n cadence --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 13"
exit 0
