#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace haven --dry-run=client -o yaml | kubectl apply -f - || true
echo "Setup complete for Question 15"
exit 0
