#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
val=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.spec.containers[1].volumeMounts[0].mountPath}' 2>/dev/null)
if [ "$val" = "/var/log" ]; then
  echo "Success: Sidecar container mount path ($val)"
  exit 0
else
  echo "Error: Sidecar container mount path - got '$val', expected '/var/log'"
  exit 1
fi
