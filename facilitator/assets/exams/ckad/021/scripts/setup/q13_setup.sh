#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace shield --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/13
echo "Setup complete for Question 13"
exit 0
