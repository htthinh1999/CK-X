#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace spark --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true

echo "Setup complete for Question 15"
exit 0
