#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
mkdir -p /tmp/exam/course/13
kubectl create namespace jungle --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
echo "Setup complete for Question 13"
exit 0
