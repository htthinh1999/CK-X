#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace pinnacle --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/11
echo "Setup complete for Question 11"
exit 0
