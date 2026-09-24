#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get resourcequota priority-quota -n eden >/dev/null 2>&1; then
  echo "Success: resourcequota priority-quota exists in eden"
  exit 0
fi
echo "Error: resourcequota priority-quota not found in eden"
exit 1
