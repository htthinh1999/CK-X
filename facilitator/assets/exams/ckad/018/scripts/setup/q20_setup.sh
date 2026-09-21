#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace aria --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete deployment local-app -n aria --ignore-not-found=true 2>/dev/null || true
kubectl delete service local-app-svc -n aria --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 20"
exit 0
