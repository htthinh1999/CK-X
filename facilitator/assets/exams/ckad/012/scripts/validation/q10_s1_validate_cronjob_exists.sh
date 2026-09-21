#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get cronjob cleanup-job -n stronghold >/dev/null 2>&1; then
  echo "Success: CronJob cleanup-job exists in stronghold"
  exit 0
else
  echo "Error: CronJob cleanup-job exists in stronghold - not found"
  exit 1
fi
