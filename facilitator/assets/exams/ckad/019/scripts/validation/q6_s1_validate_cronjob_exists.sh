#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get cronjob siege-report -n siege >/dev/null 2>&1 && { echo "Success: cronjob siege-report exists"; exit 0; }
echo "Error: cronjob siege-report not found"; exit 1
