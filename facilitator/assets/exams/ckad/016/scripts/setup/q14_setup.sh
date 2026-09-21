#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace storm --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete secret db-credentials -n storm --ignore-not-found=true >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/14
echo "Setup complete for Question 14"
exit 0
