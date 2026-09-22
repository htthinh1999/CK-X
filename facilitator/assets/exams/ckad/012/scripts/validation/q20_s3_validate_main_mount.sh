#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null)
if [ "$val" = "/var/log" ]; then
  echo "Success: Main container mount path ($val)"
  exit 0
else
  echo "Error: Main container mount path - got '$val', expected '/var/log'"
  exit 1
fi
