#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# adapter may be a regular container or a native sidecar (init container with restartPolicy: Always)
adapter=$(kubectl get pod wind-logger -n gale -o json 2>/dev/null | jq -r '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))][] | select(.name == "adapter") | .name' 2>/dev/null)
if [ "$adapter" == "adapter" ]; then
  echo "Success: adapter container present in wind-logger"
  exit 0
else
  echo "Error: adapter container not found in pod wind-logger (gale)"
  exit 1
fi
