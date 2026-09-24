#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get resourcequota compute-quota -n crown >/dev/null 2>&1; then
  echo "Success: resourcequota compute-quota exists in crown"
  exit 0
fi
echo "Error: resourcequota compute-quota not found in crown"
exit 1
