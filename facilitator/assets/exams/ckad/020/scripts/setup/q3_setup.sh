#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace primal --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 3"
exit 0
