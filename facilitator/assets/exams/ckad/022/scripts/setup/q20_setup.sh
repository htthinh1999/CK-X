#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace triumph --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/20
echo "Setup complete for Question 20"
exit 0
