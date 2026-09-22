#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# my-release is created in Q2 and upgraded here in Q3 (do NOT pre-create it)
kubectl create namespace tide --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true

echo "Setup complete for Question 3"
exit 0
