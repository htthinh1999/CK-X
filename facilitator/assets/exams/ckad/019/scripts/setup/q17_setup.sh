#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace vanguard --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl create namespace bastion --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/17

echo "Setup complete for Question 17"
exit 0
