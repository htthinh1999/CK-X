#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace eclipse --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 4"
exit 0
