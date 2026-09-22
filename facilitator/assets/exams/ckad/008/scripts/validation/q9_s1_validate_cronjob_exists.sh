#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

if kubectl get cronjob date-job -n mist >/dev/null 2>&1; then
  echo "Success: cronjob date-job exists"; exit 0
else
  echo "Error: cronjob date-job not found"; exit 1
fi
