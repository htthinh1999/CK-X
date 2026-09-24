#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace customs --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# start clean: the student creates both objects
kubectl -n customs delete pod declarations --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n customs delete secret broker-creds --ignore-not-found >/dev/null 2>&1 || true

echo "Setup complete for Question 3"
exit 0
