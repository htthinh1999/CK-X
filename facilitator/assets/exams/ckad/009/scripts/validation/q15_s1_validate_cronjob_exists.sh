#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get cronjob deadline-cron -n grove >/dev/null 2>&1; then
  echo "Success: cronjob deadline-cron exists in grove"; exit 0
else
  echo "Error: cronjob deadline-cron not found in grove"; exit 1
fi
