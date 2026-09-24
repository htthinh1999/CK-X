#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace mastery --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/8
echo "Setup complete for Question 8"
exit 0
