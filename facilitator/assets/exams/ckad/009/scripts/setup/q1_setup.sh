#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace grove --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
kubectl delete pod nginx -n grove --ignore-not-found=true >/dev/null 2>&1 || true
kubectl delete service nginx -n grove --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 1"
exit 0
