#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace chorus --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete networkpolicy port-range-allow -n chorus --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 6"
exit 0
