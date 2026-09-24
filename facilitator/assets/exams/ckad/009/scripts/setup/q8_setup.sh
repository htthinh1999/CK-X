#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace glade --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/8 2>/dev/null || true
echo "Setup complete for Question 8"
exit 0
