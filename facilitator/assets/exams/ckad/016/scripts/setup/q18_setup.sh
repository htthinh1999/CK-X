#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace bolt --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete pod secure-net -n bolt --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 18"
exit 0
