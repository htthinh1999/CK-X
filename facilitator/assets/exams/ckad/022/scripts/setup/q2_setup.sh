#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace summit --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/2
echo "Setup complete for Question 2"
exit 0
