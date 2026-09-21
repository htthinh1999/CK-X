#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace matrix --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 17"
exit 0
