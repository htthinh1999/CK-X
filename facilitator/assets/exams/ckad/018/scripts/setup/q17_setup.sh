#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace verse --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete networkpolicy egress-external-only -n verse --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 17"
exit 0
