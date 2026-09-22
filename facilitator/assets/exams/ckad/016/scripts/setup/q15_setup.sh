#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace voltage --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete configmap app-args -n voltage --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete pod arg-reader -n voltage --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 15"
exit 0
