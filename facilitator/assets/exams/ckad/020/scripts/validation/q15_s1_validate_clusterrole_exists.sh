#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get clusterrole monitor-viewer >/dev/null 2>&1; then
  echo "Success: clusterrole monitor-viewer exists"
  exit 0
fi
echo "Error: clusterrole monitor-viewer not found"
exit 1
