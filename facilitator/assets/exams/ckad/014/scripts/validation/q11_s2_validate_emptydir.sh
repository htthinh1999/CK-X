#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
vols=$(kubectl get pod logger -n lunar -o jsonpath='{.spec.volumes[*].emptyDir}' 2>/dev/null)
if [ -n "$vols" ]; then
  echo "Success: emptyDir volume is used"
  exit 0
else
  echo "Error: no emptyDir volume found on pod logger"
  exit 1
fi
