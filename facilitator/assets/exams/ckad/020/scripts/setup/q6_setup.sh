#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace matrix --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 6"
exit 0
