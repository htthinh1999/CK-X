#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace thunder --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete pod thunder-logger -n thunder --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 2"
exit 0
