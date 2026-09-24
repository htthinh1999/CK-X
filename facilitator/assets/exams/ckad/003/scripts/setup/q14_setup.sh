#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace ember --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true

echo "Setup complete for Question 14"
exit 0
