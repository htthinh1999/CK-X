#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod data-pod -n rice -o jsonpath='{.spec.volumes[?(@.name=="data-volume")].emptyDir}' 2>/dev/null)
if [ "$val" = "{}" ]; then
  echo "Success: emptyDir volume data-volume exists"
  exit 0
else
  echo "Error: emptyDir volume data-volume missing (got '$val')"
  exit 1
fi
