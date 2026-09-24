#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace refuge --dry-run=client -o yaml | kubectl apply -f - || true
echo "Setup complete for Question 5"
exit 0
