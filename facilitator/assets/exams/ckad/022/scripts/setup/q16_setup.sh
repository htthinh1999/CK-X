#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace glory --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/16
echo "Setup complete for Question 16"
exit 0
