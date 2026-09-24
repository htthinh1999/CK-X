#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=spectra

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# The student creates the Pod from scratch
kubectl -n "$NS" delete pod prism --ignore-not-found --wait=false >/dev/null 2>&1 || true

echo "Setup complete for Question 11"
exit 0
