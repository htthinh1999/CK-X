#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# log-reader may be a regular container or a native sidecar (init container with restartPolicy: Always)
val=$(kubectl get pod logger-app -n stronghold -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "log-reader") | (.volumeMounts // [])[] | select(.mountPath == "/var/log") | .mountPath' 2>/dev/null | head -n1)
if [ "$val" = "/var/log" ]; then
  echo "Success: Sidecar container mount path ($val)"
  exit 0
else
  echo "Error: Sidecar container 'log-reader' has no volume mounted at '/var/log'"
  exit 1
fi
