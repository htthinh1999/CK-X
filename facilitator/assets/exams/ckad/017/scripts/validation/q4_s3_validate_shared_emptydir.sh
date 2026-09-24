#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
vol=$(kubectl get pod log-generator -n tide -o jsonpath='{.spec.volumes[?(@.name=="shared-logs")].emptyDir}' 2>/dev/null)
if [ -n "$vol" ]; then
  echo "Success: shared-logs emptyDir volume exists"; exit 0
fi
echo "Error: shared-logs emptyDir volume not found"; exit 1
