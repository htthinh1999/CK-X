#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace crown --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/15
echo "Setup complete for Question 15"
exit 0
