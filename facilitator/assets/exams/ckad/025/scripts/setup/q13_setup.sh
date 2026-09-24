#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=nightly
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# The student creates the CronJob from scratch
kubectl -n "$NS" delete cronjob star-catalog-sync --ignore-not-found >/dev/null 2>&1 || true

echo "Setup complete for Question 13"
exit 0
