#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace harmony --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete pod health-check -n harmony --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 7"
exit 0
