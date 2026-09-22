#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace ledger --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

# start clean: the student creates the CronJob and the manual Job
kubectl -n ledger delete job reconcile-manual-01 --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n ledger delete cronjob reconcile --ignore-not-found --wait=false >/dev/null 2>&1 || true

echo "Setup complete for Question 9"
exit 0
