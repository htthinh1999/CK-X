#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace storm --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete pod app-with-wait -n storm --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 8"
exit 0
