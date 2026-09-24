#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Student creates exec-pod. Ensure namespace + output dir.
kubectl create namespace storm --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/13 || true

echo "Setup complete for Question 13"
exit 0
