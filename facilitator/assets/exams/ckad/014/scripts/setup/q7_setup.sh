#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace twilight --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 7"
exit 0
