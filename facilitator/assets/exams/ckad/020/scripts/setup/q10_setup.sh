#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace origin --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 10"
exit 0
