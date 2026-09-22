#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace zenith --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/4
echo "Setup complete for Question 4"
exit 0
