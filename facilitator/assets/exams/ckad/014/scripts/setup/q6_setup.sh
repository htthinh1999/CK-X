#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

kubectl create namespace shadow --dry-run=client -o yaml | kubectl apply -f - || true

echo "Setup complete for Question 6"
exit 0
