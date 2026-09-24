#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get cronjob db-backup -n zenith >/dev/null 2>&1; then
  echo "Success: cronjob db-backup exists in zenith"
  exit 0
fi
echo "Error: cronjob db-backup not found in zenith"
exit 1
