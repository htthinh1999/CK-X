#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace guardian --dry-run=client -o yaml | kubectl apply -f - || true
echo "Setup complete for Question 14"
exit 0
