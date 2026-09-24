#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get cronjob source-cron -n thicket >/dev/null 2>&1; then
  echo "Success: cronjob source-cron exists in thicket"; exit 0
else
  echo "Error: cronjob source-cron not found in thicket"; exit 1
fi
