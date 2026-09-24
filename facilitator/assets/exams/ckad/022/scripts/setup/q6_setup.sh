#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace legacy --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/6
echo "Setup complete for Question 6"
exit 0
