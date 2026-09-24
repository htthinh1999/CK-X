#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get cronjob lightning-strike -n bolt >/dev/null 2>&1; then
  echo "Success: cronjob lightning-strike exists"; exit 0
fi
echo "Error: cronjob lightning-strike not found in bolt"; exit 1
