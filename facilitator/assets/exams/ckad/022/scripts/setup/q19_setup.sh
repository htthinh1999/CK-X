#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace ascend --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/19
echo "Setup complete for Question 19"
exit 0
