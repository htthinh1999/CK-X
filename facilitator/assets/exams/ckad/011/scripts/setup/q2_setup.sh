#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

# Namespace for the helm release
kubectl create namespace tide --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# Make the bitnami chart available (student installs my-release themselves)
helm repo add bitnami https://charts.bitnami.com/bitnami >/dev/null 2>&1 || true
helm repo update >/dev/null 2>&1 || true

echo "Setup complete for Question 2"
exit 0
