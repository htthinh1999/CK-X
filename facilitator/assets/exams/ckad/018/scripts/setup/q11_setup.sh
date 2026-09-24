#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace rhythm --dry-run=client -o yaml | kubectl apply -f - 2>/dev/null || true
kubectl delete job data-cleanup -n rhythm --ignore-not-found=true 2>/dev/null || true
echo "Setup complete for Question 11"
exit 0
