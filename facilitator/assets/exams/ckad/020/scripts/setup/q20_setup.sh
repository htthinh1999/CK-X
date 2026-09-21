#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace nexus --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 20"
exit 0
