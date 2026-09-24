#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace charge --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete networkpolicy strict-ingress -n charge --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 5"
exit 0
