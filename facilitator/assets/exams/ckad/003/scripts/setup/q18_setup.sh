#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace magma --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
mkdir -p /tmp/exam/course/18

echo "Setup complete for Question 18"
exit 0
