#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace ward --dry-run=client -o yaml | kubectl apply -f - || true
echo "Setup complete for Question 11"
exit 0
