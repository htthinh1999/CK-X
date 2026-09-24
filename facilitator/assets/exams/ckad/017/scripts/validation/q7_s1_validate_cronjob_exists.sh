#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get cronjob data-sync -n coral >/dev/null 2>&1; then
  echo "Success: cronjob data-sync exists in coral"; exit 0
fi
echo "Error: cronjob data-sync not found in coral"; exit 1
