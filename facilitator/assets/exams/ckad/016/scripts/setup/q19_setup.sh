#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace flash --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete service sticky-svc -n flash --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 19"
exit 0
