#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace starlight --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 18"
exit 0
