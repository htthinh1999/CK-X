#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace starlight --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 9"
exit 0
