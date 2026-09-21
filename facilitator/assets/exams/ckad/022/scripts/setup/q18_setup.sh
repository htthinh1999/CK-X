#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace mastery --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/18
echo "Setup complete for Question 18"
exit 0
