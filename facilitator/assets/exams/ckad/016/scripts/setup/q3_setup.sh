#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace spark --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete clusterrole secret-reader --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete clusterrolebinding secret-reader-binding --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 3"
exit 0
