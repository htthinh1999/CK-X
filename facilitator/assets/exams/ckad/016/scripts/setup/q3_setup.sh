#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace bolt --dry-run=client -o yaml | kubectl apply -f - || true
kubectl delete cronjob lightning-strike -n bolt --ignore-not-found=true >/dev/null 2>&1 || true
echo "Setup complete for Question 3"
exit 0
