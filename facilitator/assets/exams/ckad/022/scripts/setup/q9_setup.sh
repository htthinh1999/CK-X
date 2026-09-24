#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace summit --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/9
echo "Setup complete for Question 9"
exit 0
