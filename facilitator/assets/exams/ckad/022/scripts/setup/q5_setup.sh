#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace crown --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/5
echo "Setup complete for Question 5"
exit 0
