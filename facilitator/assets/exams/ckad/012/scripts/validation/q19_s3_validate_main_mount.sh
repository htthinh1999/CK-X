#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get pod logger-app -n stronghold -o json 2>/dev/null | jq -r '.spec.containers[] | select(.name == "app") | (.volumeMounts // [])[] | select(.mountPath == "/var/log") | .mountPath' 2>/dev/null | head -n1)
if [ "$val" = "/var/log" ]; then
  echo "Success: Main container mount path ($val)"
  exit 0
else
  echo "Error: Main container 'app' has no volume mounted at '/var/log'"
  exit 1
fi
