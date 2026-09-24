#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get backup daily-backup -n aurora >/dev/null 2>&1; then
  echo "Success: Backup daily-backup exists"
  exit 0
else
  echo "Error: Backup daily-backup not found"
  exit 1
fi
