#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace nightfall --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 16"
exit 0
