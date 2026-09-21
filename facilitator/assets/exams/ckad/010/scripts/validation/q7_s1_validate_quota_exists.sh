#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get resourcequota compute-quota -n fortune >/dev/null 2>&1; then
  echo "Success: ResourceQuota compute-quota exists in fortune"
  exit 0
else
  echo "Error: ResourceQuota compute-quota not found in fortune"
  exit 1
fi
