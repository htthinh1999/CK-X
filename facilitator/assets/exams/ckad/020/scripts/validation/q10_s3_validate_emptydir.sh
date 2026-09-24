#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
vol=$(kubectl get pod data-transformer -n origin -o jsonpath='{.spec.volumes[?(@.name=="shared-data")].emptyDir}' 2>/dev/null)
if [ -n "$vol" ]; then
  echo "Success: shared-data emptyDir volume found"
  exit 0
fi
echo "Error: shared-data emptyDir volume not found"
exit 1
