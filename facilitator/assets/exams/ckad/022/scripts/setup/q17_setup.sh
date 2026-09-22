#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace legacy --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/17
echo "Setup complete for Question 17"
exit 0
