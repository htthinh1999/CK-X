#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace plasma --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete pod complex-app -n plasma --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 11"
exit 0
