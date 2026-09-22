#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace anchor --dry-run=client -o yaml | kubectl apply -f - || true
echo "Setup complete for Question 19"
exit 0
