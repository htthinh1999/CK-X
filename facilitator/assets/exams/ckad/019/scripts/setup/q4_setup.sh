#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace fortress --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/4

echo "Setup complete for Question 4"
exit 0
