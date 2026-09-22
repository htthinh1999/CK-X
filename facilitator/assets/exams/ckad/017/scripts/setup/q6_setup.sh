#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace reef --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
echo "Setup complete for Question 6"
exit 0
